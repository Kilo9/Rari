class Car < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :model, :year, :price, :image
end
