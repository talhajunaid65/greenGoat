class ProjectMailer < ApplicationMailer
	layout 'mailer'
	default from: 'thegoat@greengoat.org'
 
  def other_type_project(user, project)
    @user  = user
    @project = project
    mail(to: @user.email, subject: 'Donation estimation update')
  end

  def less_estimate(user, project)
    @user  = user
    @project = project
    mail(to: @user.email, subject: 'Donation estimation update')
  end

  def estimate_email(user, project, estimate, msg)
    @user  = user
    @project = project
    @estimate = estimate
    @msg = msg
    mail(to: @user.email, subject: 'Donation estimation update')
  end

  def old_house_estimate(user, project, msg)
    @user  = user
    @project = project
    @msg = msg
    mail(to: @user.email, subject: 'Donation estimation update')
  end

  def wrong_donation_data(project, user_email)
    @project = project
    mail(to: user_email, subject: 'Donation estimation update')
  end	

end
