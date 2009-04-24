require 'test_helper'

class RestaurantTest < ActiveSupport::TestCase
  should_have_many :restaurant_user_history, :restaurant_user_rating
  should_belong_to :group

  should_ensure_length_in_range :name, 4..40
  should_ensure_length_in_range :description, 0..80
  should_ensure_length_in_range :category, 0..20
  should_validate_uniqueness_of :name, :scoped_to => :group_id
  should_validate_presence_of :name
  should_validate_presence_of :category
end
