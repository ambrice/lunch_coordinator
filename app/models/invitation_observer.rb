class InvitationObserver < ActiveRecord::Observer
  def after_create(invitation)
    InvitationMailer.deliver_invitation(invitation)
  end
end
