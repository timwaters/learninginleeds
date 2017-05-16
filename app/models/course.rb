class Course < ApplicationRecord
  belongs_to :subject, required: false
  belongs_to :venue
  belongs_to :provider
  
end
