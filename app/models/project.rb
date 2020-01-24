class Project < ApplicationRecord
  belongs_to :admin_user

  has_many :tasks
  has_many :products
  has_many :group_items

  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :group_items, allow_destroy: true

  enum type_of_project: [:gut, :full, :kitchen, :other]
  enum status: [:not_pursuing, :appraisal_notes, :propsal, :contract]
end
