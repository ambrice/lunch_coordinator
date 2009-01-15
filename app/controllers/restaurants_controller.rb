class RestaurantsController < ApplicationController
  before_filter :login_required, :only => ['create', 'delete', 'edit']

  def index
    @restaurants = Restaurant.find(:all)
  end

  def show
    @restaurant = Restaurant.find(params[:id])
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    @restaurant = Restaurant.new(params[:restaurant])
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
end
