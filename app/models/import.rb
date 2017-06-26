class Import < ApplicationRecord
  
  has_attached_file :csv_file,
    path: ":rails_root/tmp/:class/:attachment/:id_partition/:filename", 
    url:  ":rails_root/tmp/:class/:attachment/:id_partition/:filename",
    preserve_files: false

  validates_attachment :csv_file,   content_type: { content_type: ["text/csv", "text/plain"] }
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
    Course.destroy_all # TODO make this optional?
  end

  def finish_import
    self.status = "finished"
    self.finished_at = Time.now
    self.save
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
                          target_group: row[:target_group],
                          status: row[:course_status],
                          qualification: row[:qualification],
                          hours: row[:learning_hours].to_f,
                          target_number: row[:target_no].to_i,
                          enrolment_count: row[:enrolment_count],
                          provider_code: row[:provider_course_code],
                          academic_year: row[:academic_year],
                          start_date: row[:start_date],
                          end_date: row[:end_date],
                          start_time: row[:start_time],
                          end_time: row[:end_time],
                          category_1: row[:category_1],
                          category_2: row[:category_2]
      })
      unless updated
        log_error "Could not update course: #{course.inspect}" 
        next
      end

      provider = Provider.find_or_create_by(name: row[:provider])
      telephone = row[:contact_tel_no]
      telephone = nil if telephone[0] == "?"

      updated = provider.update({ url: row[:provider_url], telephone: row[:contact_tel_no]})
      unless updated
        log_error "Could not update provider: #{provider.inspect}" 
      end
  
      venue = Venue.find_or_create_by(name: row[:venue])
      updated = venue.update({
        postcode: row[:venue_postcode].strip,
        area: row[:area],
        committee: row[:community_committee],
        ward: row[:ward], 
        address_1: row[:address_1],
        address_2: row[:address_2],
        address_3: row[:address_3]
      })

      if updated
        lookup_address = [row[:venue],row[:address_1],row[:address_2],row[:address_3],row[:venue_postcode].strip].select {|a| !a.blank?}.join(", ")
        log_error lookup_address.inspect
        lon_lat = Course.get_lon_lat(lookup_address, "google")
        
        unless lon_lat.nil?
          venue.latitude = lon_lat[:latitude]
          venue.longitude = lon_lat[:longitude]
        end
        
        venue.save
      else
        log_error "Could not update venue: #{venue.inspect}" 
      end

      subject = Subject.find_or_create_by(code: row[:sector_subject_area])
      updated = subject.update({description: row[:sector_subject_area_description]})

      unless updated
        log_error "Could not update subject: #{subject.inspect}" 
      end

      course.venue = venue
      course.provider = provider
      course.subject = subject
      
      course.latitude = venue.latitude
      course.longitude = venue.longitude
      course.lonlat = "POINT(#{venue.longitude} #{venue.latitude})" unless venue.longitude.nil?

      course.save
      count += 1
      print "."
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
