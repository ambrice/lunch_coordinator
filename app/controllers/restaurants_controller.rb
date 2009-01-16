class RestaurantsController < ApplicationController
  before_filter :login_required
  before_filter :group_required

  def index
    @restaurants = current_user.group.restaurant
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(params[:restaurant])
    @restaurant.group_id = current_user.group_id
    if @restaurant.save
      flash[:notice] = "Restaurant created"
      redirect_to restaurants_url
    else
      render :action => :new
    end
  end

  def edit
    @restaurant = Restaurant.find(params[:id])
  end

  def update
    @restaurant = Restaurant.find(params[:id])
    @restaurant.update_attributes(params[:restaurant])
    redirect_to restaurants_url
  end

  def destroy
    Restaurant.find(params[:id]).destroy
    redirect_to restaurants_url
  end

protected

  def group_required
    unless current_user.group
      flash[:error] = "Must join a lunch group first"
      redirect_to groups_url
    end
  end
end
