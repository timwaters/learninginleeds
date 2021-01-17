class AddAltAndPositionToTopics < ActiveRecord::Migration[5.2]
  def change
    add_column :topics, :alt_text, :string
    add_column :topics, :position, :integer
  end
end
