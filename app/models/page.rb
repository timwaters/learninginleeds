class Page < ApplicationRecord
  validates :name, uniqueness: true

  after_update :clear_cache

  def clear_cache
    ApplicationController.expire_page('/lil/about.html')
  end



end
