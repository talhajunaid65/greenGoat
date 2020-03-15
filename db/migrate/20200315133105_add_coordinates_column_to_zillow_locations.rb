class AddCoordinatesColumnToZillowLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :zillow_locations, :latitude, :float
    add_column :zillow_locations, :longitude, :float
  end
end
