class Activity < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :task

  validates_presence_of :activity_type, :user_id

  enum activity_type: {
    project_status_changed: 'project_status_changed',
    task_added: 'task_added',
    task_completed: 'task_completed'
  }

  delegate :title, to: :task, prefix: true, allow_nil: true
  delegate :id, :status, to: :project, prefix: true, allow_nil: true
end
