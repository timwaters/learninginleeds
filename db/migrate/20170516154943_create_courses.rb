class CreateCourses < ActiveRecord::Migration[5.1]
  def change
    create_table :courses do |t|
      t.string :title
      t.string :description
      t.string :target_group
      t.string :status
      t.string :qualification
      t.date :start_date
      t.date :end_date
      t.time :start_time
      t.time :end_time
      t.float :hours
      t.integer :target_number
      t.integer :enrolment_count
      t.string :lcc_code
      t.string :provider_code
      t.string :academic_year

      t.timestamps
    end
  end
end
