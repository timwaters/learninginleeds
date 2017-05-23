class ChangeEastingAndNorthingOnPostcodes < ActiveRecord::Migration[5.1]
  def change
    change_column :postcodes, :easting, :integer
    change_column :postcodes, :northing, :integer
  end
end
