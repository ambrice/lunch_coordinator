class CreateRestaurantUserHistories < ActiveRecord::Migration
  def self.up
    create_table :restaurant_user_histories do |t|
      t.integer :user_id
      t.integer :restaurant_id
      t.integer :selections_since_picked

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurant_user_histories
  end
end
