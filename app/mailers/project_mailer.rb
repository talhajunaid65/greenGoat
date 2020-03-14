class ProjectMailer < ApplicationMailer
	layout 'mailer'
	default from: 'info@greengoat.com'
  @@emails_send = ['abauman@greengoat.org']

  def other_type_project(user, project)
    @user  = user
    @project = project
    emails_send = @@emails_send
    emails_send << @user.email
    mail(to: emails_send, subject: 'Donation estimation update')
  end

  def less_estimate(user, project)
    @user  = user
    @project = project
    emails_send = @@emails_send
    emails_send << @user.email
    mail(to: emails_send, subject: 'Donation estimation update')
  end

  def estimate_email(user, project, estimate, msg)
    @user  = user
    @project = project
    @estimate = estimate
    @msg = msg
    emails_send = @@emails_send
    emails_send << @user.email

    mail(to: emails_send, subject: 'Donation estimation update')
  end

  def old_house_estimate(user, project, msg)
    @user  = user
    @project = project
    @msg = msg
    emails_send = @@emails_send
    emails_send << @user.email
    mail(to: emails_send, subject: 'Donation estimation update')
  end

  def wrong_donation_data(project, user_email)
    @project = project
    emails_send = @@emails_send
    emails_send << user_email
    mail(to: emails_send, subject: 'Donation estimation update')
  end

  def contact_us(email, query)
    @query = query
    @email = email
    emails_send = @@emails_send
    emails_send << 'tech@greengoat.org'
    mail(to: emails_send, subject: 'User Query')
  end

  def scheduled_tour_user_email(prospect)
    @user = prospect.user
    @project = prospect
    mail(to: @user.email, subject: 'Scheduled tour for your prospect - greenGoat')
  end

  def scheduled_tour_admin_email(user:, prospect:)
    @user = user
    @project = prospect
    mail(to: @user.email, subject: 'Scheduled tour for prospect - greenGoat')
  end
end
