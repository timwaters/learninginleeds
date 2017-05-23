namespace :import do
  require 'csv'
  
  desc "Imports courses, providers and venues from the export CSV. options FILE=coursefinder.csv"
  task coursefinder: :environment do
    file = ENV['FILE']
    unless !file.blank? && File.exist?(file)
      puts "Could not find #{file.to_s}"
      puts "USAGE 'rake import:coursefinder FILE=/path/to/coursefinder.csv'"
      break
    end
    
    rows = CSV.read(file, :headers => true, :header_converters => :symbol,  :col_sep => ",")
    puts "preparing to import courses from CSV with #{rows.size} rows"
    count = 0
    errors = 0
    existing = {courses: 0, providers: 0, venues: 0, subjects: 0}
    
    rows.each do | row |
      course = nil
      if Course.exists?(lcc_code: row[:lcc_course_code])
        course = Course.where(lcc_code: row[:lcc_course_code]).first
        existing[:courses] += 1
      else
        #maybe find or create if we update attributes
      course = Course.new(title: row[:course_title], 
                          description: row[:course_description],
                          target_group: row[:target_group],
                          status: row[:course_status],
                          qualification: row[:qualification],
                          hours: row[:learning_hours].to_f,
                          target_number: row[:target_no].to_i,
                          enrolment_count: row[:enrolment_count],
                          lcc_code: row[:lcc_course_code].strip,
                          provider_code: row[:provider_course_code],
                          academic_year: row[:academic_year],
                          start_date: row[:start_date],
                          end_date: row[:end_date],
                          start_time: row[:start_time],
                          end_time: row[:end_time]
                         )
      end
      provider = nil
      if Provider.exists?(name: row[:provider])
        provider = Provider.where(name: row[:provider]).first
        existing[:providers] += 1
      else
        provider = Provider.new(name: row[:provider], url: row[:provider_url], telephone: row[:contact_tel_no])
        provider.save
      end
  
      venue = nil
      if Venue.exists?(name: row[:venue])
        venue = Venue.where(name: row[:venue]).first
        existing[:venues] += 1
      else
        venue = Venue.new(name: row[:venue],
                          postcode: row[:venue_postcode].strip,
                          area: row[:area], 
                          committee: row[:community_committee],
                          ward: row[:ward])
        #geocode latitude and longitude, easting, northing, postcode_no_space also?
        #from Postcode model
        postcode_lookup = Postcode.where(postcode: row[:venue_postcode].strip).first
        unless postcode_lookup.nil?
          venue.postcode_no_space = postcode_lookup[:postcode_no_space]
          venue.latitude = postcode_lookup[:latitude]
          venue.longitude = postcode_lookup[:longitude]
          venue.easting = postcode_lookup[:easting]
          venue.northing = postcode_lookup[:northing]
        end
        
        venue.save
      end

      subject = nil
      if Subject.exists?(:code => row[:sector_subject_area])
        subject = Subject.where(code: row[:sector_subject_area]).first
        existing[:subjects] += 1
      else
        subject = Subject.new(code: row[:sector_subject_area], description: row[:sector_subject_area_description])
        subject.save
      end
    
      course.venue = venue
      course.provider = provider
      course.subject = subject

      course.save
      count += 1
      print "."
    end


    puts " "
    puts "count: #{count} rows processed"
    puts "existing records found: #{existing} "
  end
  

  desc "imports postcodes from csv"
  task postcodes: :environment do
      #postcodes csv got from https://www.getthedata.com/open-postcode-geo
      #derived from the ONS Postcode Directory which is licenced under the Open Government Licence and the Ordnance Survey OpenData Licence. 

      #using subset of just W.Yorks postcodes, around 11mb, 97804 records
    file = ENV['FILE']
    unless !file.blank? && File.exist?(file)
      puts "Could not find #{file.to_s}"
      puts "USAGE 'rake import:postcodes FILE=/path/to/postcodes.csv'"
      break
    end

    rows = CSV.read(file, :headers => true, :header_converters => :symbol,  :col_sep => ",")
    puts "Current total postcodes in db #{Postcode.count}"
    puts "preparing to import courses from CSV with #{rows.size} rows"
    count = 0
    errors = 0  
    
    rows.each_slice(5000).each do | group |
      postcodes = []
      group.each do | row |
        postcode = Postcode.new(
          postcode: row[:postcode],
          easting:  row[:easting],
          northing: row[:northing],
          latitude: row[:latitude],
          longitude: row[:longitude],
          postcode_no_space: row[:pc_no_space]       )
        postcodes << postcode
        count += 1
        print "."
      end
     
      puts "saving #{count}"
      Postcode.import postcodes
      
    end #in groups
    puts " "
    puts "count: #{count} rows processed"
    puts "Total postcodes in db #{Postcode.count}"

  end


end
