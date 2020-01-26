class Task < ApplicationRecord
  default_scope { order(completed: :desc) }

  has_many :notes

  accepts_nested_attributes_for :notes, allow_destroy: true

  scope :hot_tasks, -> { where(is_hot: true) }
end
