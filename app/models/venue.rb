class Venue < ApplicationRecord
  has_many :courses
  validates :name, presence: true
  validates :postcode, presence: true
end
