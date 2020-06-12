class ApplicationMailer < ActionMailer::Base
  default from: 'info@greengoat.com'
  @@receivers = ['abauman@greengoat.org']
  layout 'mailer'
end
