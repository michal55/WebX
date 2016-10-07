class User < ActiveRecord::Base
  validates_presence_of :login
  validates_presence_of :password
  validates_uniqueness_of :login
end
