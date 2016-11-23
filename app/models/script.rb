class Script < ActiveRecord::Base
  belongs_to :project
  acts_as_paranoid
  validates :name, :presence => true
end
