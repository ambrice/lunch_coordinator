class CreateRestaurantUserRatings < ActiveRecord::Migration
  def self.up
    create_table :restaurant_user_ratings do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :rating

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurant_user_ratings
  end
end
