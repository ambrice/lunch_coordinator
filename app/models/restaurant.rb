class Restaurant < ActiveRecord::Base
  has_many :restaurant_user_history
  has_many :restaurant_user_rating
  belongs_to :group

  validates_length_of :name, :within => 4..40
  validates_length_of :description, :maximum => 80
  validates_length_of :category, :maximum => 20
  validates_uniqueness_of :name, :scope => :group_id
  validates_presence_of :name
  validates_presence_of :category
end
