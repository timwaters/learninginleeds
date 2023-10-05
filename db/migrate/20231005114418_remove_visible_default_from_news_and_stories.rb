class RemoveVisibleDefaultFromNewsAndStories < ActiveRecord::Migration[5.2]
  def change
    change_column_default :stories, :visible, from: true, to: false
    change_column_default :news, :visible, from: true, to: false
  end
end
