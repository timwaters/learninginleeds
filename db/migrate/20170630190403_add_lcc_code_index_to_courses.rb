class AddLccCodeIndexToCourses < ActiveRecord::Migration[5.1]
  def change
    add_index :courses, :lcc_code
  end
end
