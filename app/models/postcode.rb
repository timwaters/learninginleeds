class Postcode < ApplicationRecord
validates :postcode, uniqueness: true

  def self.find_postcode(query)
    query_no_space = query.delete(" ").upcase
    Postcode.where(postcode_no_space: query_no_space)
  end

end
