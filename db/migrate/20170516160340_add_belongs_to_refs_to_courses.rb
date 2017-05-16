class AddBelongsToRefsToCourses < ActiveRecord::Migration[5.1]
  def change
    add_reference :courses, :venue, foreign_key: true
    add_reference :courses, :provider, foreign_key: true
    add_reference :courses, :subject, foreign_key: true
  end
end
