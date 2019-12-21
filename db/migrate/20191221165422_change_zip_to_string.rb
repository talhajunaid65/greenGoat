class ChangeZipToString < ActiveRecord::Migration[5.2]
  def change
  	change_column :projects, :zip, :string
  	change_column :zillow_locations, :zip, :string
  end
end
