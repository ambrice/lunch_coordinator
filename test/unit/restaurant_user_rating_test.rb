require 'test_helper'

class RestaurantUserRatingTest < ActiveSupport::TestCase
  should_belong_to :user
  should_belong_to :restaurant
end
