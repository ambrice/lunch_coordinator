require 'test_helper'

class GroupTest < ActiveSupport::TestCase
  should_have_many :user
  should_have_many :restaurant
  should_have_many :invitations
  should_belong_to :owner

  should_validate_presence_of :name, :owner_id, :hashed_password, :salt
  should_validate_uniqueness_of :name

  context "A Group instance" do
    setup do
      @group = Group.new
      @group.name = 'created_group'
      @group.owner = users(:aaron)
    end

    should "confirm password" do
      @group.password = 'stuff'
      @group.password_confirmation = 'junk'
      assert !@group.save
      @group.password_confirmation = 'stuff'
      assert @group.save
    end

    should "authenticate" do
      assert_respond_to(Group, :authenticate)
      assert Group.authenticate(groups(:testgroup).name, '1234')
      assert !Group.authenticate(groups(:testgroup).name, '1235')
    end
  end
end
