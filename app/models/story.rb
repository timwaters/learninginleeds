class Story < ApplicationRecord
  after_commit :clear_cache

  self.per_page = 20  #will paginate

  def clear_cache
    ApplicationController.expire_home
  end

end
