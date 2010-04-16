class CreateTags < ActiveRecord::Migration
  def self.up
    create_table :tags do |t|
      t.integer :restaurant_id
      t.string :name, :limit => 20

      t.timestamps
    end
  end

  def self.down
    drop_table :tags
  end
end
