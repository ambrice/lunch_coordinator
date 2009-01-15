class RestaurantUserRatingsController < ApplicationController
  before_filter :login_required
  before_filter :group_required

  def index
    @user = current_user
    restaurants = current_user.group.restaurant
    # Make sure an entry exists for this user for each restaurant
    restaurants.each do |restaurant|
      unless (RestaurantUserRating.find_by_user_id_and_restaurant_id(@user.id, restaurant.id))
        tmp = RestaurantUserRating.new( :user_id => @user.id, :restaurant_id => restaurant.id )
        tmp.save
      end
    end
    @ratings = RestaurantUserRating.find_all_by_user_id(@user.id)
    @valid_ratings = [ 0, 1, 2, 3, 4, 5 ]
  end

  def save_ratings
    params[:user_rating].each do |id, attributes|
      RestaurantUserRating.find(id).update_attributes(attributes)
    end
    flash[:notice] = "Ratings have been saved"
    redirect_to :action => 'list'
  end

  def show_users
    @rating_users = current_user.group.users
  end

  def show_ratings
    user_id = params[:selected_user]
    if (user_id == "")
      flash[:error] = "Please select a user"
      redirect_to :action => 'show_users'
    else
      @user = User.find(user_id)
      @ratings = RestaurantUserRating.find_all_by_user_id(user_id)
    end
  end

protected

  def group_required
    unless current_user.group
      flash[:error] = "Must join a group first"
      redirect_to groups_url
    end
  end
end
