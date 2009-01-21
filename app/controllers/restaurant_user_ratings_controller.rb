class RestaurantUserRatingsController < ApplicationController
  before_filter :login_required
  before_filter :group_required

  def index
    @user = current_user
    restaurants = @group.restaurant
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

  def update_all
    params[:user_rating].each do |id, attributes|
      RestaurantUserRating.find(id).update_attributes(attributes)
    end
    flash[:notice] = "Ratings have been saved"
    redirect_to group_restaurant_user_ratings_url(@group)
  end

protected

  def group_required
    @group = Group.find(params[:group_id])
    unless @group.id == current_user.group.id
      flash[:error] = "Not a member of that group"
      redirect_to root_url
    end
  end
end
