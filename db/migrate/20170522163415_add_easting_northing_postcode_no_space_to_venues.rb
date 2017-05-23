class AddEastingNorthingPostcodeNoSpaceToVenues < ActiveRecord::Migration[5.1]
  def change
   add_column :venues, :easting, :integer
   add_column :venues, :northing, :integer
   add_column :venues, :postcode_no_space, :string
  end
end
