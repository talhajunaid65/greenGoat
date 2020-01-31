class CreateProjectProducts < ActiveRecord::Migration[5.2]
  def change
    create_table :project_products do |t|
      t.references :product, index: true, foreign_key: true
      t.references :project, index: true, foreign_key: true

      t.timestamps
    end
  end
end
