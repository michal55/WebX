class Extraction < ActiveRecord::Base
  has_many :instances
  has_many :extraction_data
  belongs_to :script
  acts_as_paranoid
end
