class AddAttachmentCsvFileToImports < ActiveRecord::Migration[5.1]
  def self.up
    change_table :imports do |t|
      t.attachment :csv_file
    end
  end

  def self.down
    remove_attachment :imports, :csv_file
  end
end
