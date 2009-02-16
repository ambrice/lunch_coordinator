class CreateInvitations < ActiveRecord::Migration
  def self.up
    create_table :invitations do |t|
      t.integer :group_id
      t.string :email, :limit => 100

      t.timestamps
    end
  end

  def self.down
    drop_table :invitations
  end
end
