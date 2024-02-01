class Import < ApplicationRecord
  has_many :courses
  
  has_attached_file :csv_file,
    path: ":rails_root/tmp/:class/:attachment/:id_partition/:filename", 
    url:  ":rails_root/tmp/:class/:attachment/:id_partition/:filename",
    preserve_files: false

  validates_attachment :csv_file,   content_type: { content_type: ["text/plain", "text/csv", "application/vnd.ms-excel", "application/octet-stream"] }
  #validates_presence_of :csv_file, :message => "Sorry the CSV File needs to be present", :on => :create

  before_create :download_remote_image, :if => :upload_url_provided?
  after_initialize :default_values

  def upload_url_provided?
    !self.upload_url.blank?
  end

  def run_import!
    prepare_run
    do_import
    finish_import
  end

  def default_values
    self.status ||= "ready"
    self.imported_num ||= 0
  end

  def prepare_run
    self.update_attribute(:status, "running")
  end

  def finish_import
    self.status = "finished"
    self.finished_at = Time.now
    self.save
    Course.where.not(import_id: self.id).destroy_all  #delete old courses
    log_info "Finished import #{Time.now}"
  end


  def do_import
    file = self.csv_file.path
    rows = CSV.read(file, :headers => true, :header_converters => :symbol,  :col_sep => "," , encoding: "ISO8859-1:utf-8")
    log_info "preparing to import courses from CSV with #{rows.size} rows"
    count = 0
    errors = 0
    
    rows.each do | row |
      course = Course.find_or_create_by(lcc_code: row[:lcc_course_code].strip)

      updated = course.update({title: row[:course_title], 
                          description: row[:course_description],
                          description_rtf: row[:course_description_rtf],
                          hours: row[:learning_hours].to_f,
                          provider_code: row[:provider_course_code],
                          start_date: row[:start_date],
                          end_date: row[:end_date],
                          start_time: row[:start_time],
                          end_time: row[:end_time],
                          category_1: row[:category_1],
                          category_2: row[:category_2],
                          target_group: row[:target_group]
      })
      unless updated
        log_error "Could not update course: #{course.inspect}" 
        next
      end

      if course.start_time.nil? or course.end_time.nil?
        log_error "Error: Could not create or update course, no start or end time. #{course.inspect}"
        next
      end
      
      provider = Provider.find_or_create_by(name: row[:provider])
      telephone = row[:contact_tel_no]
      telephone = nil if telephone && telephone[0] == "?"

      email = row[:contact_email]
      email = nil if email && email[0] == "?"

      updated = provider.update({ url: row[:provider_url], telephone: telephone, email: email })
      unless updated
        log_error "Could not update provider: #{provider.inspect}" 
      end
  
      venue = Venue.find_or_create_by(name: row[:venue])

      updated = venue.update({
        postcode: row[:venue_postcode].strip,
        address_1: row[:address_1],
        address_2: row[:address_2],
        address_3: row[:address_3]
      })

      if venue.saved_changes?
        log_error "venue changed #{venue.name}"

        lookup_address = [row[:venue],row[:address_1],row[:address_2],row[:address_3],row[:venue_postcode].strip].select {|a| !a.blank?}.join(", ")
        lon_lat = Course.get_lon_lat(lookup_address, "google")
 
        if lon_lat && lon_lat[:latitude] > 54.50 #hacky fix for google approximate results
          lookup_address = [row[:address_1],row[:address_2],row[:address_3],row[:venue_postcode].strip].select {|a| !a.blank?}.join(", ")
          lon_lat = Course.get_lon_lat(lookup_address, "google")
        end

        unless lon_lat.nil?
          venue.latitude = lon_lat[:latitude]
          venue.longitude = lon_lat[:longitude]
        end
        
        venue.save
      end

      unless updated
        log_error "Could not update venue: #{venue.inspect}" 
      end
      
      #if the venue doesn't have a name or a postcode, or is otherwise invalid, make sure that the corresponding course is not saved
      if venue.invalid?
        course.destroy
        next
      end

      course.venue = venue
      course.provider = provider

      course.latitude = venue.latitude
      course.longitude = venue.longitude
      course.lonlat = "POINT(#{venue.longitude} #{venue.latitude})" unless venue.longitude.nil?
      course.description_html = course.convert_description
     
      course.save
      count += 1
      print "."

      self.courses << course
    end

    self.update_attribute(:imported_num, count)
    Topic.update_counts

    log_info " "
    log_info "count: #{count} rows processed"
  end


  protected

  def download_remote_image
    csv_upload = do_download_remote_image
    unless csv_upload
      errors.add(:upload_url, "error with CSV URL")  
      return false
    end
    self.csv_file = csv_upload
      
  end

  def do_download_remote_image
    begin
      io = open(URI.parse(upload_url))
      def io.original_filename
        filename =  base_uri.path.split('/').last
        
        if  !filename.blank?
          basename = File.basename(filename,File.extname(filename)) + '_'+('a'..'z').to_a.shuffle[0,8].join
          extname = File.extname(filename)
          filename = basename + extname
        end
        
        filename
      end
      io.original_filename.blank? ? nil : io
    rescue => e
      logger.debug "Error with URL upload"
      logger.debug e
      return false
    end
  end
  

  def log_info(msg)
    puts msg  if defined? Rake
    logger.info msg
  end
  
  def log_error(msg)
    puts msg  if defined? Rake
    logger.error msg
  end

end
