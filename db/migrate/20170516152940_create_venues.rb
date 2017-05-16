class CreateVenues < ActiveRecord::Migration[5.1]
  def change
    create_table :venues do |t|
      t.string :name
      t.string :postcode
      t.string :area
      t.string :committee
      t.string :ward

      t.timestamps
    end
  end
end
