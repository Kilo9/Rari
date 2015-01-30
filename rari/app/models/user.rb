class User < ActiveRecord::Base
  has_many :cars
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :on => :create
  validates_presence_of :name, :on => :create
  has_secure_password

  #returns the formatted date of when the user joined
  def birthday
    return self.created_at.strftime('%b %-d %Y')
  end

end
