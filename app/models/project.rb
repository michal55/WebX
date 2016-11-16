class Project < ActiveRecord::Base
  has_many :script
  has_many :data_schemas
  belongs_to :user
  validates :name, :presence => true
  acts_as_paranoid
end
