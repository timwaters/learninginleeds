class Topic < ApplicationRecord
  has_and_belongs_to_many :subjects
  accepts_nested_attributes_for :subjects
end
