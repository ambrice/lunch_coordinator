require 'test_helper'

class GroupsControllerTest < ActionController::TestCase
  context "on GET to :index" do
    setup do
      login_as(:aaron)
      get :index
    end

    should_assign_to :groups
    should_respond_with :success
    should_render_template :index
    should_not_set_the_flash
  end

  context "on GET to :show" do
    setup do
      login_as(:aaron)
      get :show, :id => groups(:testgroup).id
    end

    should_assign_to :group
    should_assign_to :users
    should_respond_with :success
    should_render_template :show
  end

  context "on GET to :new" do
  end

  context "on POST to :create" do
  end

end
