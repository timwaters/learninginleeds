class AddVisibilityBodyFieldsToProvider < ActiveRecord::Migration[5.2]
  def change
    add_column :providers, :visible, :boolean, :default => false
    add_column :providers, :body, :text
  end
end
