class News < ApplicationRecord
  validates :body, length: { maximum: 600 }
  validates :alt_text, presence: true, unless: -> { thumbnail.blank? }

  after_commit :clear_cache

  def clear_cache
    ApplicationController.expire_home
  end

end
