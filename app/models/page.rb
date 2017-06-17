class Page < ApplicationRecord
  validates :name, uniqueness: true
  #todo cache about page
end
