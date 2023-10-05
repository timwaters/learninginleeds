class AddExcerptTitleThumbnailToNews < ActiveRecord::Migration[5.2]
  def change
    add_column :news, :excerpt, :text
    add_column :news, :title, :string
    add_column :news, :thumbnail, :string
    add_column :news, :visible, :boolean, default: true
  end
end
