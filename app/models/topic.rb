class Topic < ApplicationRecord

  has_attached_file :icon,
    :styles => {:thumb => ["70x70>", :png]},
    :url => '/icons/:id/:style/:basename.:extension',
    preserve_files: false,
    default_url: ->(attachment) { ActionController::Base.helpers.asset_path('generic.png') }

  validates_attachment :icon, content_type: { content_type: ["image/jpg", "image/jpeg","image/pjpeg", "image/png","image/x-png", "image/gif"] }

  before_save :update_count
  after_commit :clear_cache

  def category_1=(values)
    values = values.delete_if{|v|v.blank? }
    write_attribute(:category_1, values)
  end

  def category_2=(values)
    values = values.delete_if{|v|v.blank? }
    write_attribute(:category_2, values)
  end
  
  def has_courses?
    count_courses > 0
  end

  def categories
    (category_1 + category_2).join(", ")
  end

  def update_count
    cats = (category_1 + category_2).join(", ")
    count = Course.category_search(cats).count
    self.count_courses = count
  end

  def self.update_counts
    Topic.all.each do | topic |
      cats = (topic.category_1 + topic.category_2).join(", ")
      count = Course.category_search(cats).count
      topic.update_columns(count_courses: count)
    end
  end

  def clear_cache
    ApplicationController.expire_home
    ActionController::Base.new.expire_fragment(%r{topicnav.*})
    ActionController::Base.new.expire_fragment(%r{topicnav_quick*})
  rescue ArgumentError => e 
    logger.error "ArgumentError clearing cache after topic commit " + e.inspect  
    #rescue invalid % encoding errors where theres strange encoding in cache see bug #33201 in rails 
    Rails.cache.clear
  end

end
