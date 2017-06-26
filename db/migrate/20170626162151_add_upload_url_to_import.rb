class AddUploadUrlToImport < ActiveRecord::Migration[5.1]
  def change
    add_column :imports, :upload_url, :string
  end
end
