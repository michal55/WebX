class Instance < ActiveRecord::Base
  has_many :extraction_data
  belongs_to :extraction
end
