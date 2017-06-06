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

  paginates_per 30

  #reindexes all records and returns the number of reindexed records
  def self.fts_reindex
     PgSearch::Multisearch.rebuild(Course)
     return Course.count
  end
  

  def self.search(q, options = {})
    page = options[:page] || 1
    sort = options[:sort] || "relevance"
    near = options[:near] || nil

    page = 1 if options[:page].blank?
   
    origin = Course.get_origin(near)
    
    columns_select = "*"
    columns_select = "*, ST_Distance(lonlat, ST_GeomFromText('#{origin}',4326), true) / 1000 as distance"  unless near.blank? || origin.blank?
    
    distance_sort = nil

    if origin && sort == "distance"
      distance_sort = "distance ASC" 
    end
    
    if q.blank?
     courses = Course.includes([:venue, :provider]).all.page(page).select(columns_select).order(distance_sort)
    else
      courses = Course.includes([:venue, :provider]).page(page).select(columns_select).order(distance_sort).full_search(q)
    end

    
  courses
  end 

  #postcode, lat,lon, place/address
  def self.get_origin(near)
    return nil if near.blank?
    origin = nil

    #match lon,lat string e.g. "-1.6813015,153.9s037866"
    if near.match(/^(\-?\d+(\.\d+)?),\s*(\-?\d+(\.\d+)?)$/)
      lon = near.split(",")[0]
      lat = near.split(",")[1]
      origin = "POINT (#{lon} #{lat})"

      #match UK postcode e.g. LS12 1DE from https://stackoverflow.com/a/7259020
    elsif near.match(/^(([gG][iI][rR] {0,}0[aA]{2})|((([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y]?[0-9][0-9]?)|(([a-pr-uwyzA-PR-UWYZ][0-9][a-hjkstuwA-HJKSTUW])|([a-pr-uwyzA-PR-UWYZ][a-hk-yA-HK-Y][0-9][abehmnprv-yABEHMNPRV-Y]))) {0,}[0-9][abd-hjlnp-uw-zABD-HJLNP-UW-Z]{2}))$/)
  
      postcode = Postcode.find_postcode(near)

      unless postcode.empty?
        origin  = "POINT (#{postcode.first.longitude} #{postcode.first.latitude})"
      end

    else
      origin = nil

    end



    return  origin
  end

end



