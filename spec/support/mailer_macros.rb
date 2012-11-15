module MailerMacros
  def last_email
    ActionMailer::Base.deliveries.last  # Access an array of sent emails and fetches the last one
  end  
  
  def reset_email
    ActionMailer::Base.deliveries = []
  end
end