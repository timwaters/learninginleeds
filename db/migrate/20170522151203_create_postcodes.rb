class CreatePostcodes < ActiveRecord::Migration[5.1]
  def change
    create_table :postcodes do |t|
      t.string :postcode
      t.float :easting
      t.float :northing
      t.float :latitude
      t.float :longitude
      t.string :postcode_no_space

      t.timestamps
    end
  end
end
