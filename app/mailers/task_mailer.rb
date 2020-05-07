class TaskMailer < ApplicationMailer
  layout 'mailer'
  default from: 'info@greengoat.com'
  @@emails_send = ['abauman@greengoat.org']

  def task_completed(task)
    @task = task
    @project = task.project
    @user = project.user

    mail(to: @user.email, subject: 'Task Completed')
  end

  def new_task_added(task)
    @task = task
    @project = task.project
    @user = project.user

    mail(to: @user.email, subject: 'New Task Added')
  end
end