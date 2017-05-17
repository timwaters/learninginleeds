class Course < ApplicationRecord
  belongs_to :subject, required: false
  belongs_to :venue, required: false
  belongs_to :provider, required: false

  validates :lcc_code, uniqueness: { case_sensitive: false }
end
