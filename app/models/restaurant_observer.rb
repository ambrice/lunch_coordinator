class RestaurantObserver < ActiveRecord::Observer
  def before_destroy(restaurant)
    RestaurantUserHistory.delete_all "restaurant_id = #{restaurant.id}"
    RestaurantUserRating.delete_all "restaurant_id = #{restaurant.id}"
  end
end

