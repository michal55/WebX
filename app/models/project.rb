class Project < ActiveRecord::Base
  has_many :script
  belongs_to :user
  acts_as_paranoid
end
