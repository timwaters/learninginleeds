class CreateStories < ActiveRecord::Migration[5.2]
  def change
    create_table :stories do |t|
      t.string  :title
      t.string  :thumbnail
      t.text    :body
      t.text    :excerpt
      t.boolean :visible, default: true 

      t.timestamps
    end
  end
end
