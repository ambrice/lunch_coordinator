require 'test_helper'

class RestaurantUserHistoryTest < ActiveSupport::TestCase
  should_belong_to :user
  should_belong_to :restaurant
  should_validate_presence_of :selections_since_picked

  context "A Restaurant User History instance" do
    setup do
      @ruh = restaurant_user_histories(:aaron_redlobster_history)
      assert @ruh
      @old_selections = @ruh.selections_since_picked
    end

    should "increment if not picked" do
      @ruh.picked(restaurants(:chinobandito).id)
      assert_equal(@ruh.selections_since_picked, @old_selections + 1)
    end

    should "reset if picked" do
      @ruh.picked(restaurants(:redlobster).id)
      assert_equal(@ruh.selections_since_picked, 0)
    end
  end
end
