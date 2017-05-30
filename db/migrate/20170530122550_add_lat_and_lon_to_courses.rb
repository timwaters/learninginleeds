class AddLatAndLonToCourses < ActiveRecord::Migration[5.1]
  def change
   add_column :courses, :latitude, :float
   add_column :courses, :longitude, :float
  end
end
