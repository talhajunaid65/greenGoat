class ProjectProduct < ApplicationRecord
  belongs_to :product
  belongs_to :project

  validates :product_id, uniqueness: { scope: :project_id }
end
