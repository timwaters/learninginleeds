class News < ApplicationRecord
  validates :body, length: { maximum: 600 }

  after_commit :clear_cache

  def clear_cache
    ApplicationController.expire_home
  end

end
