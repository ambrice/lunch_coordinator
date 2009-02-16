class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Please activate your new account'
  
    @body[:url]  = activate_url(user.activation_code)
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Your account has been activated!'
    @body[:url]  = root_url
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "do-not-reply@lunchcoordinator.com"
      @subject     = "Lunch Coordinator -- "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
