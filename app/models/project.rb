class Project < ApplicationRecord
  has_many :tasks
  has_many :products
  has_many :group_items

  belongs_to :pm, class_name: 'AdminUser', foreign_key: 'pm_id'
  belongs_to :appraiser, class_name: 'AdminUser', foreign_key: 'appraiser_id'
  belongs_to :contractor, class_name: 'AdminUser', foreign_key: 'contractor_id'
  belongs_to :architect, class_name: 'AdminUser', foreign_key: 'architect_id'

  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :group_items, allow_destroy: true

  enum type_of_project: [:gut, :full, :kitchen, :other]
  enum status: [:not_pursuing, :appraisal_notes, :propsal, :contract]

  scope :contract_projects, -> { where(status: 'contract') }
  scope :pm_projects, -> (pm_id) { where(pm_id: pm_id) }
  scope :appraiser_projects, -> (appraiser_id) { where(appraiser_id: appraiser_id) }
  scope :contractor_projects, -> (contractor_id) { where(contractor_id: contractor_id) }
  scope :architect_projects, -> (architect_id) { where(architect_id: architect_id) }
end
