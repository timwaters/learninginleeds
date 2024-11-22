class Provider < ApplicationRecord
  has_many :courses
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  after_commit :clear_cache

  def clear_cache
    ApplicationController.expire_providers
  end
end
