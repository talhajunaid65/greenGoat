class UserMailer < ApplicationMailer
  layout 'mailer'
  default from: 'info@greengoat.com'
  @@emails_send = ['abauman@greengoat.org']

  def reset_password_instruction(email:, reset_password_token:)
    @email = email
    @reset_password_token = reset_password_token
    mail(subject: 'Reset password instructions', to: @email)
  end
end
