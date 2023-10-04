class Story < ApplicationRecord
  after_save :clear_cache

  self.per_page = 20  #will paginate

  def clear_cache
    ApplicationController.expire_home
  end

end
