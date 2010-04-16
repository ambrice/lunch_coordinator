class Restaurant < ActiveRecord::Base
  has_many :restaurant_user_history
  has_many :restaurant_user_rating
  has_many :tags
  belongs_to :group

  validates_length_of :name, :within => 4..40
  validates_length_of :description, :maximum => 80
  validates_uniqueness_of :name, :scope => :group_id
  validates_presence_of :name

  def tag_list
    tags.map { |t| t.name }
  end

  def set_tag_list(ltags)
    mytags = tag_list
    ltags.each do |t|
      Tag.new(:name => t.downcase, :restaurant_id => self.id).save if not mytags.include?(t.downcase)
    end
    mytags.each do |t|
      tags.find_by_name(t.downcase).destroy if not ltags.include?(t.downcase)
    end
  end

  def tags_string
    tag_list.join(' ')
  end

  def tags_string=(ltags)
    set_tag_list(ltags.split(/[,\s]+/))
  end
end
