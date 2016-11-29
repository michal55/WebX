class Script < ActiveRecord::Base
  belongs_to :project
  has_many :frequencies
  acts_as_paranoid
  validates :name, :presence => true
end
