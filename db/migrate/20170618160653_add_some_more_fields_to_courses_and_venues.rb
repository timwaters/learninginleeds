class AddSomeMoreFieldsToCoursesAndVenues < ActiveRecord::Migration[5.1]
  def change
    add_column :venues, :address_1, :string
    add_column :venues, :address_2, :string
    add_column :venues, :address_3, :string
    add_column :courses, :category_1, :string
    add_column :courses, :category_2, :string
  end
end
