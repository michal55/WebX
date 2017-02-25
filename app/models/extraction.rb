class Extraction < ActiveRecord::Base
  has_many :extraction_data
  acts_as_paranoid
end
