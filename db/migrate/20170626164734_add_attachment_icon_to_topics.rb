class AddAttachmentIconToTopics < ActiveRecord::Migration[5.1]
  def self.up
    change_table :topics do |t|
      t.attachment :icon
    end
  end

  def self.down
    remove_attachment :topics, :icon
  end
end
