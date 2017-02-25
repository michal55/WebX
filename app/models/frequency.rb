class Frequency < ActiveRecord::Base
  belongs_to :script
  acts_as_paranoid
end
