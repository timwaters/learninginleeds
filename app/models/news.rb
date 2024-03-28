class News < ApplicationRecord
  validates :body, presence: true
  validates :excerpt, presence: true
  validates :title, presence: true
  validates :alt_text, presence: true, unless: -> { thumbnail.blank? }

  after_commit :clear_cache

  def clear_cache
    ApplicationController.expire_home
  end

end
