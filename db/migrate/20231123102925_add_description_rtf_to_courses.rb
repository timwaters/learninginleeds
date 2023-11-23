class AddDescriptionRtfToCourses < ActiveRecord::Migration[5.2]
  def change
    add_column :courses, :description_rtf, :text
    add_column :courses, :description_html, :text
  end
end
