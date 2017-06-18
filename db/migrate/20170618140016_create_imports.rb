class CreateImports < ActiveRecord::Migration[5.1]
  def change
    create_table :imports do |t|
      t.string :status
      t.integer :course_count
      t.string :filename

      t.timestamps
    end
  end
end
