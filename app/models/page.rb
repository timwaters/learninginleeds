class Page < ApplicationRecord
  validates :name, uniqueness: true
end
