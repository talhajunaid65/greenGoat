class AddSqftColumnToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :sqft, :string
  end
end
