class Project < ApplicationRecord
  default_scope { order(is_hot: :desc, updated_at: :desc) }

  belongs_to :pm, class_name: 'AdminUser', foreign_key: 'pm_id'
  belongs_to :appraiser, class_name: 'AdminUser', foreign_key: 'appraiser_id'
  belongs_to :contractor, class_name: 'AdminUser', foreign_key: 'contractor_id'
  belongs_to :architect, class_name: 'AdminUser', foreign_key: 'architect_id'
  belongs_to :zillow_location

  has_many :tasks
  has_many :products
  has_many :group_items

  has_one_attached :picture

  accepts_nested_attributes_for :tasks, allow_destroy: true
  accepts_nested_attributes_for :group_items, allow_destroy: true

  enum type_of_project: [:gut, :full, :kitchen, :other]
  enum status: [:not_pursuing, :appraisal_notes, :propsal, :contract]

  validates :name, :type_of_project, :status, presence: true

  scope :contract_projects, -> { where(status: 'contract') }
  scope :pm_projects, -> (pm_id) { where(pm_id: pm_id) }
  scope :appraiser_projects, -> (appraiser_id) { where(appraiser_id: appraiser_id) }
  scope :contractor_projects, -> (contractor_id) { where(contractor_id: contractor_id) }
  scope :architect_projects, -> (architect_id) { where(architect_id: architect_id) }

  def to_s
    name
  end

  def first_three_hot_tasks
    tasks.hot_tasks.first(3)
  end

  def update_tasks_start_date
    tasks.update_all(start_date: contract_date)
  end
end
