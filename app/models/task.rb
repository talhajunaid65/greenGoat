class Task < ApplicationRecord
  belongs_to :project
  belongs_to :closed_by, class_name: 'AdminUser', foreign_key: 'closed_by_id'
  has_many :notes

  accepts_nested_attributes_for :notes, allow_destroy: true

  scope :hot, -> { where(is_hot: true) }
  scope :incomplete, -> { where('closed is NULL OR closed = false') }
  before_create do |task|
    task.job_number = task.generate_job_number
  end

  after_save :create_activity

  def generate_job_number
    loop do
      number = "#{project_id}#{SecureRandom.hex(2)}"
      break number unless Task.exists?(job_number: number)
    end
  end

  private

  def create_activity
    activity_type = closed? ? 'task_completed' : 'task_added'
    Activity.find_or_create_by(user: self.project.user, project: self.project, task: self, activity_type: activity_type)
  end
end
