class Project < ActiveRecord::Base
  has_many :scripts
  has_many :data_fields
  belongs_to :user
  validates :name, :presence => true
  acts_as_paranoid
end
