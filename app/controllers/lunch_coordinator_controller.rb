class LunchCoordinatorController < ApplicationController
  require 'set'

  before_filter :login_required, :only=>['select_users', 'calculate_restaurant', 'restaurant_picked']
  before_filter :group_required, :only=>['select_users', 'calculate_restaurant', 'restaurant_picked']

  SELECTION_SCALE_FACTOR = 0.1
  NEW_RESTAURANT_SCALE_FACTOR = 5
  
  def show
  end

  def select_users
    @users = current_user.group.users
    restaurants = current_user.group.restaurants
    @types = Set.new
    restaurants.each do |r|
      @types << r.restaurant_type
    end
  end

  def calculate_restaurant
    # Algorithm:
    # Calculate adjusted rating for each restaurant for each user that's going to lunch
    # adjusted rating = specified rating + (specified rating * selections since picked * SELECTION_SCALE_FACTOR)
    # average the adjusted ratings for each restaurant, then add a "new restaurant factor"
    # new restaurant factor = average adjusted rating * number of people who have never been * NEW_RESTAURANT_SCALE_FACTOR
    # Total rating for each restaurant is average adjusted rating + new restaurant factor

    @restaurants = current_user.group.restaurants
    if @restaurants.empty?
      flash[:error] = "Must add some restaurants first"
      redirect_to new_restaurant_url
    end

    @user_id_list = Array.new
    params[:user].each do |id, input|
      @user_id_list << id if input[:going_to_lunch] == 'true'
    end

    selected_type = params[:selected_restaurant_type]

    if @user_id_list.empty?
      flash[:error] = "Must select at least one person to go to lunch"
      redirect_to :action => :select_users
    end

    @users = User.find(@user_id_list)
    
    @restaurant_ratings = Hash.new { |hash, key| hash[key] = Hash.new }
    @restaurant_visited = Hash.new { |hash, key| hash[key] = Hash.new }
    @adjusted_ratings = Hash.new { |hash, key| hash[key] = Hash.new }

    # Set up rating and history data for each restaurant
    restaurant_exclude_list = Array.new
    
    @restaurants.each do |restaurant|
      if selected_type != "Any" && !restaurant.restaurant_type.nil? && selected_type != restaurant.restaurant_type
        logger.debug "Restaurant #{restaurant.name} does not match requested type #{selected_type}"
        restaurant_exclude_list << restaurant.name
        next
      end
      @users.each do |user|
        user_rating = RestaurantUserRating.find_by_restaurant_id_and_user_id( restaurant.id, user.id )
        next if user_rating.nil? || user_rating.rating.nil?
        if user_rating.rating == 0
          restaurant_exclude_list << restaurant.name
          next
        end
        @restaurant_ratings[restaurant.name][user.login] = user_rating.rating
        user_visited = RestaurantUserHistory.find_by_restaurant_id_and_user_id( restaurant.id, user.id )
        if user_visited.nil?
          RestaurantUserHistory.new(:user_id => user.id, :restaurant_id => restaurant.id, :selections_since_picked => 0).save
          @adjusted_ratings[restaurant.name][user.login] = user_rating.rating
        else
          @restaurant_visited[restaurant.name][user.login] = user_visited.selections_since_picked
          @adjusted_ratings[restaurant.name][user.login] = user_rating.rating * (1 + user_visited.selections_since_picked * SELECTION_SCALE_FACTOR)
        end
      end
    end

    # restaurant_rating and restaurant_visited have been filled out
    @restaurants.reject! { |r| restaurant_exclude_list.include?(r.name) }
    @restaurant_ratings.delete_if { |key, value| restaurant_exclude_list.include?(key) }
    @restaurant_visited.delete_if { |key, value| restaurant_exclude_list.include?(key) }
    @adjusted_ratings.delete_if { |key, value| restaurant_exclude_list.include?(key) }

    @restaurants.each do |restaurant|
      rname = restaurant.name
      @restaurant_ratings[rname][:avg] = @restaurant_ratings[rname].inject(0) { |sum, n| sum + n[1] } / @restaurant_ratings[rname].length.to_f
      @restaurant_visited[rname][:avg] = @restaurant_visited[rname].inject(0) { |sum, n| sum + n[1] } / @restaurant_visited[rname].length.to_f
      @adjusted_ratings[rname][:avg] = @adjusted_ratings[rname].inject(0) { |sum, n| sum + n[1] } / @adjusted_ratings[rname].length.to_f
    end
    @restaurants.sort! { |a,b| @adjusted_ratings[b.name][:avg] <=> @adjusted_ratings[a.name][:avg] }
    @calculated_restaurant = @restaurants[0].name
  end

  def restaurant_picked
    selected_restaurant_id = params[:selected_restaurant_id]
    user_id_list = params[:user_id_list].split(",")
    user_id_list.each do |user_id|
      @hists = RestaurantUserHistory.find_all_by_user_id(user_id)
      @hists.each { |hist| hist.picked(selected_restaurant_id) }
      unless RestaurantUserHistory.find_by_user_id_and_restaurant_id(user_id, selected_restaurant_id)
        RestaurantUserHistory.new(:user_id => user_id, :restaurant_id => selected_restaurant_id, :selections_since_picked => 0).save
      end
    end
    flash[:notice] = "Enjoy your lunch"
    redirect_to :action => 'welcome'
  end

protected

  def group_required
    unless Group.exists?(current_user.group_id)
      flash[:error] = "Must join a lunch group first"
      redirect_to :action => :welcome
    end
  end

end
