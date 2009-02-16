class InvitationMailer < ActionMailer::Base
  def invitation(invitation)
    setup_email(invitation)
    @subject    += 'You have been invited to join a Lunch Group'
  
    @body[:group]     = invitation.group.name
    @body[:user_url]  = signup_url
    @body[:join_url]  = join_group_url(invitation.group)
  end
  
protected

  def setup_email(invitation)
    @recipients  = "#{invitation.email}"
    @from        = "do-not-reply@lunchcoordinator.com"
    @subject     = "Lunch Coordinator -- "
    @sent_on     = Time.now
  end
end
