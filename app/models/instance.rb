class Instance < ActiveRecord::Base
  has_many :extraction_data, dependent: :destroy
  has_many :children, foreign_key: "parent_id", class_name: "Instance", dependent: :destroy
  belongs_to :extraction
  acts_as_paranoid
end
