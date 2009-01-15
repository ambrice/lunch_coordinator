class RestaurantUserHistory < ActiveRecord::Base
  belongs_to :user
  belongs_to :restaurant
  validates_presence_of :selections_since_picked

  def picked(restaurant_id)
    if restaurant_id.to_i == self.restaurant_id
      self.selections_since_picked = 0
      self.save
    else
      self.selections_since_picked += 1
      self.save
    end
  end
end
