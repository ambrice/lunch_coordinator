class CreateRestaurants < ActiveRecord::Migration
  def self.up
    create_table :restaurants do |t|
      t.string :name
      t.string :description
      t.string :category

      t.timestamps
    end
  end

  def self.down
    drop_table :restaurants
  end
end
