class News < ApplicationRecord

  has_rich_text :content
  has_rich_text :summary

  has_one_attached :header do |attachable|
    attachable.variant :banner, resize_to_fill: [500, 250]
    attachable.variant :thumb, resize_to_limit: [150, 150]
  end

  validate :acceptable_header

  # validates :body, presence: true
  # validates :excerpt, presence: true
  validates :content, presence: true
  validates :summary, presence: true
  validates :title, presence: true
  validates :alt_text, presence: true, unless: -> { header.blank? }

  after_commit :clear_cache

  def clear_cache
    ApplicationController.expire_home
  end

  private

  def acceptable_header
    return unless header.attached?

    unless header.blob.content_type.start_with?('image/')
      errors.add(:header, 'must be an image')
    end
  end

end
