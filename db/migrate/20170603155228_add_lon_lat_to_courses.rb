class AddLonLatToCourses < ActiveRecord::Migration[5.1]
  change_table :courses do |t|
    t.st_point :lonlat, geographic: true
    t.index :lonlat, using: :gist
  end
end
