class AddCategoryFieldToTopic < ActiveRecord::Migration[5.1]
  def change
    add_column :topics, :category_1, :text, array: true, default: []
    add_column :topics, :category_2, :text, array: true, default: []
    add_column :topics, :count_courses, :integer
  end
end
