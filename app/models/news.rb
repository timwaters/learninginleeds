class News < ApplicationRecord
  validates :body, length: { maximum: 600 }
end
