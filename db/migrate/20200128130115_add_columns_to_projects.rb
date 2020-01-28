class AddColumnsToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :contract_date, :date
    add_column :projects, :access_info, :text
    add_reference :projects, :zillow_location, index: true, foreign_key: true
  end
end
