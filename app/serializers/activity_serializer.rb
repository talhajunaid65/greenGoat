class ActivitySerializer < ActiveModel::Serializer
  attributes :activity, :created_at

  def activity
    message =
      case object.activity_type
      when 'project_status_changed'
        "Status of your donation form ID:#{object.project_id} is #{object.project_status&.titleize}."
      when 'task_added'
        "New task <b>#{object.task_title}</b> is added to your donation form ID:<b>#{object.project_id}</b>."
      when 'task_completed'
        "Task <b>#{object.task_title}</b> of your donation form ID:<b>#{object.project_id}</b>is complete."
      when 'scheduled_tour'
        "A tour is scheduled at #{object.project.visit_date.strftime('%I:%M%p')} for your donation #{object.project.title}  "
      else
        ''
      end
    message.html_safe
  end

  def created_at
    "#{object.created_at.to_date} #{object.created_at.strftime('%I:%M%p')}"
  end
end
