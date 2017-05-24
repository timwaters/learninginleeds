class Topic < ApplicationRecord
  has_and_belongs_to_many :subjects
  accepts_nested_attributes_for :subjects
  
  #TODO add manual counter for courses
  #TODO add icon for courses
  def has_courses?
    #todo change this to count
    Course.where(subject: self.subjects).exists?
  end

end
