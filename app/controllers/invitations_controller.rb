class InvitationsController < ApplicationController
  before_filter :login_required
  before_filter :group_required

  def index
    @invitations = @group.invitations
  end

  def new
    @invitation = Invitation.new
  end

  def create
    @invitation = Invitation.new(params[:invitation])
    @invitation.group_id = @group.id
    if @invitation.save
      flash[:notice] = "Invitation created"
      redirect_to group_invitations_url(@group)
    else
      render :action => :new
    end
  end

  def destroy
    Invitation.find(params[:id]).destroy
    redirect_to group_invitations_url(@group)
  end
end
