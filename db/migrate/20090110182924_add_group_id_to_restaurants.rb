class AddGroupIdToRestaurants < ActiveRecord::Migration
  def self.up
    add_column :restaurants, :group_id, :integer
  end

  def self.down
    remove_column :restaurants, :group_id
  end
end
