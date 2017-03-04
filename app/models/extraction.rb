class Extraction < ActiveRecord::Base
  has_many :instances
  belongs_to :script
  acts_as_paranoid
end
