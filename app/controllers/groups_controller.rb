class GroupsController < ApplicationController
  before_filter :login_required

  def index
    @groups = Group.all
  end

  def show
    @group = Group.find(params[:id])
    if @group
      @users = @group.user
    else
      flash[:error] = 'Unable to find group'
    end
  end

  def new
    @group = Group.new
  end

  def create
    @group = Group.new(params[:group])
    @group.owner = current_user
    if @group.save
      current_user.group = @group
      current_user.save
      flash[:notice] = 'Group Created'
      redirect_to group_url(@group)
    else
      render :action => :new
    end
  end

  def join
    @group = Group.find(params[:id])
    invitation = Invitation.find(:first, :conditions => ["group_id = ? AND LOWER(email) = ?", @group.id, current_user.email.downcase])
    if invitation
      # Bypass the group password protection if the user was invited..
      current_user.group = @group
      if current_user.save
        Invitation.destroy(invitation.id)
        flash[:notice] = "You have joined group #{@group.name}"
        redirect_to group_url(@group)
      else
        flash[:error] = "Failed to join group #{@group.name}"
        redirect_to groups_url
      end
    end
  end

  def add_user
    @group = Group.find(params[:id])
    if @group && Group.authenticate(@group.name, params[:group][:password])
      current_user.group = @group
      current_user.save
      flash[:notice] = "You have joined group #{@group.name}"
      redirect_to group_url(@group)
    else
      flash[:error] = 'Wrong password'
      render :action => :join
    end
  end

  def goto_lunch
    @group = Group.find(params[:id])
    unless (@group.id == current_user.group.id)
      flash[:error] = "Wrong group selected"
      redirect_to root_url
    end

    @users = @group.user
    restaurants = @group.restaurant

    if restaurants.empty?
      flash[:error] = "Must add some restaurants first"
      redirect_to new_group_restaurant_url(@group)
    end
  end

end
