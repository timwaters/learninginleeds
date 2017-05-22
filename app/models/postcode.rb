class Postcode < ApplicationRecord
validates :postcode, uniqueness: true
end
