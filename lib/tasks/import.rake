namespace :import do
  require 'csv'
  
  desc "Imports courses, providers and venues from the CSV URL"
  task coursefinder: :environment do
    puts "Coursefinder import from #{AppConfig['csv_upload_url']}" 
    if AppConfig['csv_upload_url'].blank?
      puts "csv_upload_url is unset or empty"
      break
    end

    import = Import.new(:note => "Automatic import", :upload_url => AppConfig["csv_upload_url"])
    import.save
    begin
      import.run_import!
    rescue => e
      import.status = "failed"
      import.note = "Automatic Import Error: #{e.to_s}  #{e.backtrace.join(', ')} "
      import.save
    end
    puts "Task finished. Import status: #{import.status}. Number Imported: #{import.imported_num}."

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

