class Instance < ActiveRecord::Base
  has_many :extraction_data
  belongs_to :extraction
  acts_as_paranoid
end
