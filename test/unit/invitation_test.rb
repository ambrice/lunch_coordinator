require 'test_helper'

class InvitationTest < ActiveSupport::TestCase
  should_belong_to :group
  should_validate_presence_of :group_id, :email
  should_validate_uniqueness_of :email, :scoped_to => :group_id

  should_ensure_length_in_range :email, 6..100
  should_allow_values_for :email, 'stuff@junk.com', 'a@b.ca'
  should_not_allow_values_for :email, 'mystuff', 'stuff.com', :message => /should look like an email/
end
