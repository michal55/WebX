class Script < ActiveRecord::Base
  belongs_to :project
  has_many :frequencies
  has_many :extractions
  acts_as_paranoid
  validates :name, :presence => true
  enum log_level: {debug: 0, warning: 1, error: 2}
end
