class Venue < ApplicationRecord
  has_many :courses
  validates :name, presence: true, uniqueness: { case_sensitive: false }
  validates :postcode, presence: true

  def is_online?
    postcode == "ZZ99 9ZZ"
  end
  
end
