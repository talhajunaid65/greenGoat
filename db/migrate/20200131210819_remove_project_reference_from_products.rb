class RemoveProjectReferenceFromProducts < ActiveRecord::Migration[5.2]
  def change
    remove_reference :products, :project, index: true
  end
end
