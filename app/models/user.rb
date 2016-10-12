class User < ActiveRecord::Base

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  before_create :default_role

  def default_role
    self.role = 'user'
  end
end
