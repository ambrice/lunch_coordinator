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
    else
      flash[:notice] = 'Failed to create group'
    end
    redirect_to group_url(@group)
  end

  def join
    group = Group.find(params[:id])
    if group && Group.authenticate(group.name, params[:group][:pass])
      current_user.group = group
      current_user.save
    end
  end

end
