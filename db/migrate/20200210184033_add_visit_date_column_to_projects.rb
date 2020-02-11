class AddVisitDateColumnToProjects < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :visit_date, :datetime
  end
end
