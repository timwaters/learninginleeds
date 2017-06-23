class Course < ApplicationRecord
  belongs_to :subject, required: false
  belongs_to :venue, required: false
  belongs_to :provider, required: false
  
  validates :lcc_code, uniqueness: { case_sensitive: false }
  
  include PgSearch
  pg_search_scope :full_search, 
                  :against =>  {:title => 'A', :description => 'B'} , 
                  :using => { :dmetaphone => {:only => [:title]},
                              :trigram => {},
                              :tsearch => {:prefix => true, :dictionary => "english", :any_word => true}
                            }

  self.per_page = 30  #will paginate

  def self.search(q, options = {})
    page = options[:page] || 1
    sort = options[:sort] || "relevance"
    lon_lat = options[:lon_lat] || nil
    page = 1 if options[:page].blank?
  
    origin = nil
    origin = "POINT (#{lon_lat[:longitude]} #{lon_lat[:latitude]})" if lon_lat

    columns_select = "*"
    columns_select = "*, ST_Distance(lonlat, ST_GeomFromText('#{origin}',4326), true) / 1000 as distance"  unless lon_lat.blank? || origin.blank?
    
    distance_sort = nil

    if origin && sort == "distance"
      distance_sort = "distance ASC" 
    end
    
    if q.blank?
     courses = Course.includes([:venue, :provider]).all.page(page).select(columns_select).order(distance_sort)
    else
      courses = Course.includes([:venue, :provider]).page(page).select(columns_select).order(distance_sort).full_search(q)
    end
  
    return courses
  end 

  #postcode, lat,lon, place/address
  def self.get_lon_lat(near)
    return nil if near.blank?
    lon_lat = nil

    #match lon,lat string e.g. "-1.6813015,153.9s037866"
    if near.match(/^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/)
      lon = near.split(",")[0]
      lat = near.split(",")[1]
      lon_lat = {:longitude => lon, :latitude => lat}

      #match UK postcode e.g. LS12 1DE from https://stackoverflow.com/a/7259020
    elsif near.match(/^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$/)
  
      postcode = Postcode.find_postcode(near)

      unless postcode.empty?
        lon_lat = {:longitude => postcode.first.longitude, :latitude => postcode.first.latitude}
      end

    else
      lon_lat = Rails.cache.fetch(near, :expires => 60.days) do
        Course.geocode(near)
      end
    end

    return lon_lat
  end


  require 'httparty'

  def self.geocode(near)

    query_params = "?" + {
      "text" => near,
      "api_key" => AppConfig['mapzen_key'],
      "size" => "1",
      "boundary.country" => "GBR",
      "focus.point.lat" => "53.797678",
      "focus.point.lon" => "-1.5359008",
      "boundary.circle.lat"  => "53.797678",
      "boundary.circle.lon" =>  "-1.5359008",
      "boundary.circle.radius" => "50"
    }.map {|k,v| "#{k}=#{CGI.escape(v)}"}*"&"
    base_url = "https://search.mapzen.com/v1/search"
   
    url=URI.parse(base_url+query_params)
    logger.debug "calling #{url}"
    
    response = HTTParty.get(url)

    return nil unless response.code == 200
   
    body = JSON.parse(response.body)

    lon_lat = {:longitude => body["features"][0]["geometry"]["coordinates"][0], :latitude =>body["features"][0]["geometry"]["coordinates"][1]} if body["features"].size > 0

    return lon_lat
  end

  #gets a walking route based using mapzen
  def walk_route(params={})

    params[:origin] ||= {:lat =>53.797678, :lon =>-1.5359008} #-1.5359008,53.797678  bus station!
    lon_lat = Course.get_lon_lat(params[:lon_lat])
    
    params[:origin] = {:lat =>lon_lat[:latitude], :lon =>lon_lat[:longitude]} if lon_lat

     params[:start_time]  ||= self.start_time.strftime("%H:%M")
    if self.start_date < Time.now
      params[:start_date] ||= Time.now.strftime("%Y-%m-%d")
    else
      params[:start_date] ||= self.start_date.strftime("%Y-%m-%d")
    end

    time = params[:start_date]+"T"+params[:start_time]
    logger.debug params.inspect
    json = {"locations" => [{"lat"=>params[:origin][:lat], "lon"=>params[:origin][:lon]},{"lat"=>self.latitude, "lon"=> self.longitude}], "directions_options"=>{"units"=>"kilometers"},"costing" => "pedestrian"  }.to_json
    
    url="https://valhalla.mapzen.com/route?json=#{json}&api_key=#{AppConfig['mapzen_key']}"
    logger.debug "calling #{url}"
    response = HTTParty.get(url)

    return nil unless response.code == 200
   
    body = JSON.parse(response.body)
   
    duration = body["trip"]["summary"]["time"] 
    length = body["trip"]["summary"]["length"]
    #TODO work out time to leave etc
    departure_time = nil
    arrival_time = nil
   
    parts = body["trip"]["legs"][0]["maneuvers"].map {| part | 
                {"mode" => "foot",
                 "pre_instruction"=> part["verbal_pre_transition_instruction"], 
                 "post_instruction" => part["verbal_post_transition_instruction"],
                 "duration" => part["time"]}    }
   
    return  {:type => "foot",
            :duration => duration,
            :length => length,
            :date => params[:start_date],
            :departure_time => departure_time,
            :arrival_time => arrival_time,
            :parts => parts }

  end


   #gets a bus route based using transport API
  def transit_route(params={})
    lon_lat = Course.get_lon_lat(params[:lon_lat])
    lon_lat = "lonlat:#{lon_lat[:longitude]},#{lon_lat[:latitude]}" if lon_lat
    origin = params[:origin] || lon_lat || "postcode:LS2+9DY"  #lonlat:-1.5359008,53.797678  bus station!

    params[:destination] ||= "lonlat:#{self.longitude},#{self.latitude}"

    if self.start_date < Time.now
      params[:start_date] ||= Time.now.strftime("%Y-%m-%d")
    else
      params[:start_date] ||= self.start_date.strftime("%Y-%m-%d")
    end

    params[:start_time]  ||= self.start_time.strftime("%H:%M")
      
    base_url="https://transportapi.com/v3/uk/public/journey"
    rest_params="/from/#{origin}/to/#{params[:destination]}/by/#{params[:start_date]}/#{params[:start_time]}.json"

    query_params = "?" + {
      "app_id" => AppConfig["transportapi_id"],
      "app_key" => AppConfig["transportapi_key"],
      "modes" => "bus",
      "service" => "southeast"
    }.map {|k,v| "#{k}=#{CGI.escape(v)}"}*"&"
  
    url=URI.parse(base_url+rest_params+query_params)
    logger.debug "calling #{url}"
    response = HTTParty.get(url)
  
    return nil unless response.code == 200
   
    body = JSON.parse(response.body)

    return nil unless body["error"].blank?
   
    route = body["routes"][0]

    duration = route["duration"]
    departure_time = route["departure_time"]
    arrival_time = route["arrival_time"]
    

    parts = route["route_parts"].map {| part | 
                {"mode" => part["mode"],
                 "from"=> part["from_point_name"], 
                 "to" => part["to_point_name"], 
                 "line_name" => part["line_name"], 
                 "departure_time" => part["departure_time"],
                 "arrival_time" => part["arrival_time"],
                 "duration" => part["duration"]}    }
    
    return  {:type => "transit",
            :duration => duration,
            :date => params[:start_date],
            :departure_time => departure_time,
            :arrival_time => arrival_time,
            :parts => parts }
  end

end



