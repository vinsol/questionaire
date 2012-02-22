class Notifier < ActionMailer::Base
  default :from => "questionnaire_admin@vinsol.com"  
  
  def contact(recipient, subject, message, sent_at = Time.now)
    @subject = subject
    @recipients = recipient
#    @from = 'questionaireAdmin@vinsol.com'
    @sent_on = sent_at
    #@body["title"] = 'This is title'
	  #@body["email"] = 'sender@yourdomain.com'
 	  @body["message"] = message
    @headers = {}
  end
end
