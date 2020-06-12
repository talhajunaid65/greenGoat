class UserMailer < ApplicationMailer
  layout 'mailer'

  def reset_password_instruction(email:, reset_password_token:)
    @email = email
    @reset_password_token = reset_password_token
    mail(subject: 'Reset password instructions', to: @email)
  end
end
