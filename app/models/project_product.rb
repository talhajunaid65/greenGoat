class ProjectProduct < ApplicationRecord
  belongs_to :product
  belongs_to :project

  validates :project_id, :product_id, presence: true
  validates :project_id, uniqueness: { scope: :product_id, message: 'already contains this product, please change project.' }
end
