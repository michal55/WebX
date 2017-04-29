class DataField < ActiveRecord::Base
  belongs_to :project
  acts_as_paranoid
  enum data_type: {string: 0, integer: 1, float: 2, link: 3, date: 4}
  validates :name, :presence => true
  validates :name, uniqueness: {scope: :project}
end
