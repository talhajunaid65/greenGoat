class Task < ApplicationRecord
  belongs_to :project
  belongs_to :closed_by, class_name: 'AdminUser', foreign_key: 'closed_by_id'
  has_many :notes

  accepts_nested_attributes_for :notes, allow_destroy: true

  scope :hot, -> { where(is_hot: true) }
  scope :incomplete, -> { where('closed is NULL OR closed = false') }
  scope :complete, -> { where(closed: true) }

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
    activity = Activity.find_or_initialize_by(user: self.project.user, project: self.project, task: self, activity_type: activity_type)
    if activity.persisted?
      TaskMailer.task_completed(self).deliver_now if closed?
    else
      activity.save
      TaskMailer.new_task_added(self).deliver_now
    end
  end
end
