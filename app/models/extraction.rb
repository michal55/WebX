class Extraction < ActiveRecord::Base
  has_many :instances, dependent: :destroy
  has_many :extraction_data, dependent: :destroy
  belongs_to :script
  acts_as_paranoid
end
