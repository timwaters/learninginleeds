class Course < ApplicationRecord
  belongs_to :subject, required: false
  belongs_to :venue, required: false
  belongs_to :provider, required: false

  validates :lcc_code, uniqueness: { case_sensitive: false }
  
  #reindexes all records into the fts_courses table based on existing courses
  #returns the number of reindexed records
  def self.fts_reindex
    #title, description, soundex
    connection = ActiveRecord::Base.connection_pool.checkout
    Course.all.each do | course |
      title = connection.quote(course.title)
      description = connection.quote(course.description)
      
      sound_words = course.title.split.select {| s | s.length > 3 }
      soundex = sound_words.map {| word | Text::Soundex.soundex word }.join(" ")
      soundex = connection.quote(soundex)
      
    # doc_count = connection.select_value("SELECT COUNT(*) FROM fts_courses WHERE docid = #{course.id}").to_i
    # doc_exists = doc_count > 0 ? true : false
      is_rake = (ENV['RACK_ENV'].blank? || ENV['RAILS_ENV'].blank? || !("#{ENV.inspect}" =~ /worker/i).blank?)
      print "." if is_rake
      connection.execute("insert or replace into fts_courses(docid, title, description, soundex) values (#{course.id}, #{title}, #{description}, #{soundex} );")
    end

    new_record_count = connection.select_value("SELECT COUNT(*) FROM fts_courses")
 
    #optimize is like a vacuum
    connection.execute("INSERT INTO fts_courses(fts_courses) VALUES('optimize')")  
    
    ActiveRecord::Base.connection_pool.checkin connection
    
    new_record_count
  end
  
 #matches =Course.fts_search("creator")
 #=> #<ActiveRecord::Result:0x00000005c4d088 @columns=["docid", "title"], @rows=[[26, "Film Making"], [60, "Conversational English Using Book Creator"], [62, "Conversational English Using Book Creator"], [63, "Conversational English Using Book Creator"]], @hash_rows=nil, @column_types={}> 

  def self.fts_search(querystring)
    connection = ActiveRecord::Base.connection_pool.checkout

    query_words = querystring.split.map { | q | "#{q}*" }
    query = query_words.join(" OR ")
    query = connection.quote(query)
        
    matches = connection.exec_query("select docid, title, offsets(fts_courses) as offsetinfo from fts_courses where fts_courses MATCH #{query} order by length(offsetinfo) DESC")
    
    ##if there's no matches, search by sonud of word e.g. englesh 
    if matches.rows.empty?
      soundex_words = querystring.split.map { | q | Text::Soundex.soundex q }
      query  = soundex_words.join(" OR ")
      query = connection.quote(query)
      
      matches  = connection.exec_query("select docid, title, offsets(fts_courses) as offsetinfo from fts_courses where soundex MATCH #{query} order by length(offsetinfo) DESC")
    end    
    
    ActiveRecord::Base.connection_pool.checkin connection
    
    matches
  end
  
  def self.search(q)
    matches = Course.fts_search(q)
    return Course.none if matches.rows.empty?
    
    #ordered by relevance = sort by ids returned
    courses_ids = matches.rows.map { | r | r[0]  }
   # #courses = Course.where(id: courses_ids)  <- unordered
    courses = Course.find_ordered(courses_ids)
    
    courses
  end

end



