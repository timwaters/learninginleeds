class Venue < ApplicationRecord
  has_many :courses
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :postcode, presence: true
  
  acts_as_mappable :default_units => :kms,
                    :default_formula => :flat,
                    :distance_field_name => :distance,
                    :lat_column_name => :latitude,
                    :lng_column_name => :longitude
end
