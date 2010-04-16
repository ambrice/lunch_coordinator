class RemoveCategoryFromRestaurants < ActiveRecord::Migration
  def self.up
    remove_column :restaurants, :category
  end

  def self.down
    add_column :restaurants, :category, :string, :default => 'unknown'
  end
end
