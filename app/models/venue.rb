class Venue < ApplicationRecord
  has_many :courses
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :postcode, presence: true
  
end
