class Page < ApplicationRecord
  validates :name, uniqueness: true

  after_commit :clear_cache

  def clear_cache
    ApplicationController.expire_about
    ApplicationController.expire_home
  end

end
