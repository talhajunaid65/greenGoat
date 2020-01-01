class ProjectMailer < ApplicationMailer
	layout 'mailer'
	default from: 'tech@greengoat.org'
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

end
