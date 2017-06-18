class Import < ApplicationRecord
  
  has_attached_file :csv_file,
    path: ":rails_root/tmp/:class/:attachment/:id_partition/:filename", 
    url:  ":rails_root/tmp/:class/:attachment/:id_partition/:filename",
    preserve_files: false

  validates_attachment :csv_file,   content_type: { content_type: ["text/csv", "text/plain"] }
  validates_presence_of :csv_file, :message => "Sorry the CSV File needs to be present"

  after_initialize :default_values

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
                          end_time: row[:end_time]
      })
      unless updated
        log_error "Could not update course: #{course.inspect}" 
        next
      end

      provider = Provider.find_or_create_by(name: row[:provider])
      updated = provider.update({ url: row[:provider_url], telephone: row[:contact_tel_no]})
      unless updated
        log_error "Could not update provider: #{provider.inspect}" 
      end
  
      venue = Venue.find_or_create_by(name: row[:venue])
      updated = venue.update({postcode: row[:venue_postcode].strip, area: row[:area], committee: row[:community_committee], ward: row[:ward]})

      if updated
        postcode_lookup = Postcode.where(postcode: row[:venue_postcode].strip).first
        unless postcode_lookup.nil?
          venue.postcode_no_space = postcode_lookup[:postcode_no_space]
          venue.latitude = postcode_lookup[:latitude]
          venue.longitude = postcode_lookup[:longitude]
          venue.easting = postcode_lookup[:easting]
          venue.northing = postcode_lookup[:northing]
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

    log_info " "
    log_info "count: #{count} rows processed"
  end


  protected
  

  def log_info(msg)
    puts msg  if defined? Rake
    logger.info msg
  end
  
  def log_error(msg)
    puts msg  if defined? Rake
    logger.error msg
  end

end
