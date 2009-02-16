class Invitation < ActiveRecord::Base
  include Authentication

  belongs_to :group

  validates_presence_of     :group_id
  validates_presence_of     :email
  validates_length_of       :email, :within => 6..100
  validates_uniqueness_of   :email, :scope => :group_id
  validates_format_of       :email, :with => Authentication.email_regex, :message => Authentication.bad_email_message
end
