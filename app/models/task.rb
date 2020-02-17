class Task < ApplicationRecord
  default_scope { order(closed: :asc) }

  belongs_to :project
  belongs_to :closed_by, class_name: 'AdminUser', foreign_key: 'closed_by_id'
  has_many :notes

  accepts_nested_attributes_for :notes, allow_destroy: true

  scope :hot_tasks, -> { where(is_hot: true, closed: false) }

  before_create do |task|
    task.job_number = task.generate_job_number
  end

  def generate_job_number
    loop do
      number = "#{project_id}#{SecureRandom.hex(2)}"
      break number unless Task.exists?(job_number: number)
    end
  end
end
