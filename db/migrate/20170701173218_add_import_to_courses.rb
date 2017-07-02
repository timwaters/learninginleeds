class AddImportToCourses < ActiveRecord::Migration[5.1]
  def change
    add_reference :courses, :import, foreign_key: true
  end
end
