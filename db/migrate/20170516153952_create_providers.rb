class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.string :name
      t.string :url
      t.string :telephone

      t.timestamps
    end
  end
end
