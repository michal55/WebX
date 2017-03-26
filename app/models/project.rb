class Project < ActiveRecord::Base
  has_many :scripts, dependent: :destroy
  has_many :data_fields, dependent: :destroy
  belongs_to :user
  validates :name, :presence => true
  acts_as_paranoid
end
