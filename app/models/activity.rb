class Activity < ApplicationRecord
  belongs_to :user

  validates_presence_of :activity_type, :user_id

  enum activity_type: {
    prospect_submitted: 'prospect_submitted',
    project_approved: 'project_approved',
    task_added: 'task_added',
    task_deleted: 'task_deleted',
    task_completed: 'task_completed'
  }
end
