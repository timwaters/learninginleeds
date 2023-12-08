class AddAltTextForStoriesAndNews < ActiveRecord::Migration[5.2]
  def change
    add_column :stories, :alt_text, :string
    add_column :news, :alt_text, :string
  end
end
