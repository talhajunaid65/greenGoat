class Product < ApplicationRecord
  has_many_attached :images
  belongs_to :project

  enum status: [:unsold, :sold, :returned, :damaged]
end
