class ProjectProduct < ApplicationRecord
  belongs_to :product
  belongs_to :project

  validates :project_id, :product_id, presence: true
  validates :product_id, uniqueness: { scope: :project_id }
end
