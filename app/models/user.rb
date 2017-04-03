class User < ActiveRecord::Base
  has_many :project

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable
  before_create :default_role
  after_create :set_api_key

  def default_role
    self.role = 'user'
  end

  def set_api_key
    self.api_key = rand(36**20).to_s(36)
  end
end
