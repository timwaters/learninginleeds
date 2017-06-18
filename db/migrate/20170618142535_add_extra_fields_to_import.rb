class AddExtraFieldsToImport < ActiveRecord::Migration[5.1]
  def change
    add_column :imports, :finished_at, :datetime
    add_column :imports, :imported_num, :integer
    add_column :imports, :note, :text
  end
end
