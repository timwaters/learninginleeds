class Course < ApplicationRecord
  belongs_to :venue, required: false
  belongs_to :provider, required: false
  belongs_to :import, required: false
  
  validates :lcc_code, uniqueness: { case_sensitive: false }
  
  include PgSearch
  pg_search_scope :full_search, 
                  :against =>  {:title => 'A', :description => 'B', :category_1 => 'C', :category_2 => 'C'} , 
                  :using => { :trigram => {:only => [:title, :description]},
                              :tsearch => {:prefix => true, :dictionary => "english", :any_word => true}
                            }

  pg_search_scope :sounds_like_search, 
                  :against =>  {:title => 'A', :description => 'B'} , 
                  :using => { :dmetaphone => {:only => [:title, :description]}
                            }

  pg_search_scope :category_search,
                  :against => {:category_1 => 'A', :category_2 => 'C'},
                  :using => { :tsearch => { :dictionary => "simple", :any_word => true}  }

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
    
    extra_sort = nil

    if origin && sort == "distance"
      extra_sort = "distance ASC" 
    elsif sort == "start_date"
      extra_sort = "start_date ASC"
    end
    
    if q.blank?
     courses = Course.includes([:venue, :provider]).all.page(page).select(columns_select).order(extra_sort)
    else
      courses = Course.includes([:venue, :provider]).page(page).select(columns_select).order(extra_sort).full_search(q)
      if courses.empty?
        courses = Course.includes([:venue, :provider]).page(page).select(columns_select).order(extra_sort).sounds_like_search(q)
      end
    end
  
    return courses
  end 

  def self.in_bounds?(lat, lon, bbox)
    lat.between?(bbox[:min_lat], bbox[:max_lat]) && 
    lon.between?(bbox[:min_lon], bbox[:max_lon])
  end

  #postcode, lat,lon, place/address
  def self.get_lon_lat(near, geocode_service="google")
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
        begin
          Course.geocode(near, geocode_service)
        rescue ApiError => e
          logger.error "Api Error #{e.message}"
          break
        rescue HTTParty::Error => e
          logger.error "HttpParty Error #{e.message}"
          break
        rescue StandardError => e
          logger.error "Standard Error  #{e.message}"
          logger.error(e.backtrace)
          break
        end
      end

    end

    return lon_lat
  end

  require 'httparty'

  def self.geocode(near, service="google")

    lon_lat = nil

    if service == "google"
    
      query_params = "?" + {
      "address" => near,
      "sensor" => "false",
      "language" => "en-GB",
      "key" => AppConfig['google_key'],
      "components" => "country:GB",
      "bounds" => "53.661323,-1.777039|53.950025,-1.244202"
      }.map {|k,v| "#{k}=#{CGI.escape(v)}"}*"&"
      base_url = "https://maps.googleapis.com/maps/api/geocode/json"
    
      url=URI.parse(base_url+query_params)
      logger.debug "calling #{url}"

      response = HTTParty.get(url)

      if response.code != 200
        msg = "Problem with Google Geocoding: Code: #{response.code.to_s} Body: " + response.body.inspect
        raise ApiError, msg
      end         
      
      body = JSON.parse(response.body)

      if body["status"] != "OK"
        msg = "Problem with Google Geocoding: Code: #{response.code.to_s} Status: " + body["status"].inspect
        raise ApiError, msg
      end
    
     
      bbox = { min_lon: -1.8787, min_lat: 53.5613, max_lon: -1.0603, max_lat: 54.0334 }
      lat  = body["results"][0]["geometry"]["location"]["lat"]
      lon = body["results"][0]["geometry"]["location"]["lng"]
      # only return if its around Leeds
      return nil unless in_bounds?(lat,lon, bbox)

      lon_lat = {:longitude => lon.round(6), :latitude =>lat.round(6)} if body["results"].size > 0

    else
      lon_lat = nil
    end
  
    return lon_lat
  end

  #gets a walking route based using OSRM router
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
    json = {"locations" => [{"lat"=>params[:origin][:lat], "lon"=>params[:origin][:lon]},{"lat"=>self.latitude, "lon"=> self.longitude}], "directions_options"=>{"units"=>"kilometers"},"costing" => "pedestrian"  }.to_json
    location = "#{params[:origin][:lon]},#{params[:origin][:lat]};#{self.longitude},#{self.latitude}"
    url = "#{AppConfig['osrm_url']}/route/v1/foot/#{location}?overview=false&alternatives=false&steps=true"

    logger.debug "calling #{url}"

    response = HTTParty.get(url, {
      headers: {"User-Agent" => "Leeds-Adult-Learning;Contact osm @chippy"} 
    })

    if response.code != 200
      msg = "Problem with OSRM walk routing: Code: #{response.code.to_s} Body: " + response.body.inspect
      raise ApiError, msg
    end
   
    body = JSON.parse(response.body)

    duration = body["routes"][0]["legs"][0]["duration"]
    length = body["routes"][0]["legs"][0]["distance"]
    departure_time = self.start_time - duration
    arrival_time = self.start_time 

    parts = []
    body["routes"][0]["legs"].each do | leg |
      leg["steps"].each do | step |
        instruction = OSRMTextInstructions.compile(step)
        parts <<    { "mode" => "foot",
          "pre_instruction" => instruction,
          "post_instruction" => "",
          "duration" => step["duration"],
          "distance" => step["distance"],
          "ref" => step["ref"]
        }   
      end
   end
   
    return  {:type => "foot",
            :duration => duration,
            :length => length,
            :date => params[:start_date],
            :departure_time => departure_time,
            :arrival_time => arrival_time,
            :parts => parts }

  end

  def transit_route_google(params={})
    lon_lat = Course.get_lon_lat(params[:lon_lat])
  
    return nil if lon_lat.nil?

    origin = "#{lon_lat[:latitude]},#{lon_lat[:longitude]}"

    destination = "#{self.latitude},#{self.longitude}"

    if self.start_date < Time.now
      course_start_date ||= Time.now # today
    else
      course_start_date ||= self.start_date 
    end

    local_time = Time.new(
      course_start_date.year,
      course_start_date.month,
      course_start_date.day,
      start_time.hour,
      start_time.min,
      start_time.sec
    )

    arrival_time = local_time.to_i.to_s

    base_url = "https://maps.googleapis.com/maps/api/directions/json"
    query_params = "?" + {
      "origin" => origin,
      "destination" => destination,
      "arrival_time"=> arrival_time,
      "language" => "en-GB",
      "region" => "uk",
      "mode" => "transit",
      "transit_mode" => "bus",
      "key" => AppConfig['google_key']
    }.map {|k,v| "#{k}=#{CGI.escape(v)}"}*"&"
    url = URI.parse(base_url+query_params)

    logger.debug "Calling #{url}"

    # require 'benchmark'
    # response = nil
    # time = Benchmark.realtime do
    # response = HTTParty.get(url)
    # end
    # puts "Request took #{time.round(3)} seconds"
    response = HTTParty.get(url)

    if response.code != 200
      msg = "Problem with Google Directions: Code: #{response.code.to_s} Body: " + response.body.inspect
      raise ApiError, msg
    end
        
    body = JSON.parse(response.body)

    return nil unless body["status"] == "OK"

    route = body["routes"][0]["legs"][0]
    
    departure_timestamp = body.dig("routes", 0, "legs", 0, "departure_time", "value")
    departure_time = departure_timestamp ? Time.at(departure_timestamp).strftime("%I:%M %p") : nil

    arrival_timestamp = body.dig("routes", 0, "legs", 0, "arrival_time", "value")
    arrival_time = arrival_timestamp ? Time.at(arrival_timestamp).strftime("%I:%M %p") : nil
    
    duration = body["routes"][0]["legs"][0]["duration"]["text"]
    distance = body["routes"][0]["legs"][0]["distance"]["text"]

    parts = body["routes"][0]["legs"][0]["steps"].map { | part | 

      line_name = ""
      short_name = part.dig("transit_details", "line", "short_name")
      long_name =  part.dig("transit_details", "line", "name")
      line_name =  "#{short_name} #{long_name}"
      part_departure_time = nil
      part_arrival_time = nil
      if part.dig("transit_details", "departure_time", "value") && part.dig("transit_details", "arrival_time", "value")
        part_departure_time = Time.at(part["transit_details"]["departure_time"]["value"]).strftime("%I:%M %p")
        part_arrival_time = Time.at(part["transit_details"]["arrival_time"]["value"]).strftime("%I:%M %p")
      end
      
      {
        "mode" => part["travel_mode"],
        "html_instructions" => part["html_instructions"],
        "duration" => part["duration"]["text"],
        "distance" => part["distance"]["text"],
        "line_name" => line_name,
        "num_stops" => part.dig("transit_details", "num_stops"),
        "from" =>  part.dig("transit_details", "departure_stop", "name"),
        "to" => part.dig("transit_details", "arrival_stop", "name"),
        "departure_time" => part_departure_time,
        "arrival_time" => part_arrival_time
      }

    }

    return  {
      :type => "transit_google",
      :duration => duration,
      :distance => distance,
      :departure_time => departure_time,
      :arrival_time => arrival_time,
      :parts => parts 
    }
 

  end

  
  # bus route via here
  def transit_route_here(params={})
    lon_lat = Course.get_lon_lat(params[:lon_lat])
  
    return nil if lon_lat.nil?

    origin = "#{lon_lat[:latitude]},#{lon_lat[:longitude]}"
    destination = "#{self.latitude},#{self.longitude}"

    if self.start_date < Time.now
      course_start_date ||= Time.now # today
    else
      course_start_date ||= self.start_date 
    end

    local_time = Time.new(
      course_start_date.year,
      course_start_date.month,
      course_start_date.day,
      start_time.hour,
      start_time.min,
      start_time.sec
    )

    arrival_time = local_time.rfc3339

    base_url = "https://transit.router.hereapi.com/v8/routes"
    query_params = "?" + {
      "origin" => origin,
      "destination" => destination,
      "arrivalTime"=> arrival_time,
      "lang" => "en-gb",
      "modes" => "bus",
      "return" => "actions,travelSummary",
      "apiKey" => AppConfig['here_key']
    }.map {|k,v| "#{k}=#{CGI.escape(v)}"}*"&"
    url = URI.parse(base_url+query_params)

    logger.debug "Calling #{url}"

    response = HTTParty.get(url)

    if response.code != 200
      msg = "Problem with Here Directions: Code: #{response.code.to_s} Body: " + response.body.inspect
      raise ApiError, msg
    end

    body = JSON.parse(response.body)

    if body.dig("notices")
      #logger.debug body.dig("notices") 
      return nil
    end

    sections = body.dig("routes", 0, "sections")
    return nil unless sections

    parts = sections.map {| part | 

      line_name = ""
      short_name = part.dig("transport", "name")
      long_name =  part.dig("transport", "headsign")
      line_name =  "#{short_name} #{long_name}"

      instructions = nil
      actions = part.dig("actions")
      if actions
        instructions = actions.map {| action |
          action.dig("instruction")
        }
      end

      {"mode" => part["type"],
        "from"=> part.dig("departure", "place", "name"), 
        "to" => part.dig("arrival", "place", "name"), 
        "line_name" => line_name, 
        "instructions" => instructions,
        "departure_time" => part.dig("departure","time"),
        "arrival_time" =>  part.dig("arrival","time"),
        "duration" => part.dig("travelSummary", "duration"),
        "distance" => part.dig("travelSummary", "length") }      

    } #part

    return  {
      :type => "transit_here",
      :duration => nil,
      :distance => nil,
      :departure_time => nil,
      :arrival_time => nil,
      :parts => parts 
    }
    
  end

   #gets a bus route based using transport API
  def transit_route_tapi(params={})
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
      "service" => "traveline"
    }.map {|k,v| "#{k}=#{CGI.escape(v)}"}*"&"
  
    url=URI.parse(base_url+rest_params+query_params)
    logger.debug "calling #{url}"

    # require 'benchmark'
    # response = nil
    # time = Benchmark.realtime do
    # response = HTTParty.get(url)
    # end
    # puts "Request took #{time.round(3)} seconds"
    response = HTTParty.get(url)
    
    if response.code != 200
     msg =  "Problem with Transport API transit routing: Code: #{response.code.to_s} Body: " + response.body.inspect
     raise ApiError, msg
    end
   
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
    
    return  {:type => "transportapi",
            :duration => duration,
            :date => params[:start_date],
            :departure_time => departure_time,
            :arrival_time => arrival_time,
            :parts => parts }
  end



  #converts rtf to html
  def convert_description
    unless self.description_rtf.blank?
      #change long blank spaces and tabs to bullet
      #change small bullets to big
      begin
        html = PandocRuby.convert(self.description_rtf.gsub("       ",'•').gsub("\\tab",'•'), from: :rtf, to: :html).gsub('·', '•')
      rescue => e
        logger.error "Error in panodoc convert #{e.inspect}"
        logger.error "Setting description_rtf to nil for #{self.inspect}"
        return nil
      end
      require 'nokogiri'
      doc = Nokogiri::HTML.fragment(html)
    
      #change paragraphs to li and remove the bullets
      doc.css('p:contains("•")').each do | n |
        li = Nokogiri::XML::Node.new("li", doc)
        li.content = n.content.gsub('•','').strip
       
        if li.content.empty?
          pp = Nokogiri::XML::Node.new("p", doc)
          n.replace pp
        else 
          n.replace li
        end 
      end

      html = doc.to_html
   
      # group the li with ul
      doc = Nokogiri::HTML.fragment(html)

      group = nil
      last_nonelement = nil
      last = doc.element_children.last()
      doc.element_children.each do | node |
        if node.name == "li"
            group =  Nokogiri::XML::Node.new "ul", doc if group.nil?
            group.add_child(node)
        end
        if node.name != "li"
          last_nonelement = node
          node.add_next_sibling(group) unless group.nil?
          group = nil
        end
        if last == node && group
          last_nonelement.add_next_sibling(group)
          group = nil
        end

      end

      doc.element_children.each do | node |
        if node.name == "p" && node.content.empty? 
          node.remove
        end
      end
      
      return doc.to_html.strip()

    else
      nil
    end
  end

  def application_form_url
    if self.lcc_code.match?(/MUL/)
      form_template  = AppConfig['form_template_multiplier']
    else
      form_template  = AppConfig['form_template']
    end
    template = form_template % {course_title: CGI.escape(self.title), course_code: self.lcc_code, start_date: self.start_date.strftime("%Y-%m-%d"), end_date: self.end_date.strftime("%Y-%m-%d"), venue_name: self.venue.name , venue_postcode: self.venue.postcode } 
    form_url = template

    return form_url
  end

  # generates a short url for the course from url shortener using httparty
  def generate_short_url
    unless AppConfig["url_shortener_url"].blank? || AppConfig["url_shortener_key"].blank? || AppConfig["url_shortener_enabled"] == false
      long_url = self.application_form_url

      base_url = AppConfig["url_shortener_url"] + "/api/v2/links"
      api_key = AppConfig["url_shortener_key"]

      # setting reuse means that if it sends it again it will get one already created
      response = HTTParty.post(
        base_url,
        headers: {
          "Content-Type" => "application/json",
          "Accept" => "application/json",
          "X-API-Key" => api_key
        },
        body: {
          target: long_url,
          reuse: true
        }.to_json
      )
      # 201 = (created new), 200 = OK (already exists)
      if response.code != 201 && response.code != 200
        msg = "Problem with URL Shortener: Code: #{response.code.to_s} Body: " + response.body.inspect
        raise ApiError, msg
      end

      body = JSON.parse(response.body)

      if body["link"].blank?
        msg = "Problem with URL Shortener: Code: #{response.code.to_s} Body: " + response.body.inspect
        raise ApiError, msg
      end

      return body["link"]
    else
      # logger.debug "No URL shortener configured"
      return nil
    end
  end

end

class ApiError < StandardError
end
