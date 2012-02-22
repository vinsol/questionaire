class Notifier < ActionMailer::Base
  default :from => "questionnaireAdmin@vinsol.com"  
  
  def contact(recipient, subject)
    @url = "http://questionbank.vinsol.com"
    mail(:to => recipient, :subject => subject)
  end
end
