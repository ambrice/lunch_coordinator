class RestaurantsController < ApplicationController
  before_filter :login_required
  before_filter :group_required

  def index
    @restaurants = @group.restaurant
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(params[:restaurant])
    @restaurant.group_id = @group.id
    if @restaurant.save
      flash[:notice] = "Restaurant created"
      redirect_to group_restaurants_url(@group)
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
    redirect_to group_restaurants_url(@group)
  end

  def destroy
    Restaurant.find(params[:id]).destroy
    redirect_to group_restaurants_url(@group)
  end
end
