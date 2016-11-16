class DataSchema < ActiveRecord::Base
  belongs_to :project
  acts_as_paranoid
  enum data_type: {string: 0, integer: 1, float: 2}
  validates :name, :presence => true
end
