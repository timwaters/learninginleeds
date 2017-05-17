class Subject < ApplicationRecord
  has_and_belongs_to_many :topics
  
  validates :code, uniqueness: { case_sensitive: false }
end
