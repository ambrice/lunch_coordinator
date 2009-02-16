require 'digest/sha1'

class Group < ActiveRecord::Base
  has_many :user
  has_many :restaurant
  has_many :invitations
  belongs_to :owner, :class_name => 'User'

  validates_presence_of :name, :owner_id, :password, :password_confirmation, :salt, :on => :create
  validates_presence_of :name, :owner_id, :hashed_password, :salt, :on => :update
  validates_uniqueness_of :name
  validates_confirmation_of :password

  attr_protected :salt
  attr_accessor :password, :password_confirmation

  def password=(pass)
    @password=pass
    self.salt = Group.random_string(10) if !self.salt?
    self.hashed_password = Group.encrypt(@password, self.salt)
  end

  def self.authenticate(name, pass)
    g=find_by_name(name)
    return nil if g.nil?
    return g if Group.encrypt(pass, g.salt)==g.hashed_password
    nil
  end

protected

  def self.random_string(len)
    #generate a random password consisting of strings and digits
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    newpass = ""
    1.upto(len) { |i| newpass << chars[rand(chars.size-1)] }
    return newpass
  end

  def self.encrypt(pass, salt)
    Digest::SHA1.hexdigest(pass+salt)
  end

end
