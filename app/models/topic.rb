class Topic < ApplicationRecord
  before_save :update_count

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

  #TODO add icon for courses
end
