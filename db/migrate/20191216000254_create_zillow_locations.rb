class CreateZillowLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :zillow_locations do |t|
      t.integer   :type_of_project
      t.string :address
      t.string :city
      t.string :state
      t.string :zip
      t.datetime :start_date
      t.string :year_built
      t.float :val_sf
      t.float :estimated_value
      t.belongs_to :user

      t.timestamps
    end
  end
end
