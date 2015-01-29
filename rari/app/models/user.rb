class User < ActiveRecord::Base
  has_many :cars
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  has_secure_password
end
