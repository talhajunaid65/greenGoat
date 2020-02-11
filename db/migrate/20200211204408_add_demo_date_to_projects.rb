class AddDemoDateToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :demo_date, :datetime
  end
end
