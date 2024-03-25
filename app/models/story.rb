class Story < ApplicationRecord
  validates :alt_text, presence: true, unless: -> { thumbnail.blank? }
  
  after_commit :clear_cache

  self.per_page = 20  #will paginate

  def clear_cache
    ApplicationController.expire_home
  end

end
