class AddPromotionToTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :promotion, :text
  end
end
