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

    @types = Set.new
    @types << 'Any'
    restaurants.each do |r|
      @types << r.category
    end
  end

end
