class ChangeCourseTargetGroupToText < ActiveRecord::Migration[5.1]
  def change
    change_column :courses, :target_group, :text
  end
end
