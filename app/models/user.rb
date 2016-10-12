class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  # validates_presence_of :login
  # validates_presence_of :password
  # validates_uniqueness_of :email
  before_create :default_role

  def default_role
    self.role = 'user'
  end
end
