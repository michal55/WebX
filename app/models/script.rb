class Script < ActiveRecord::Base
	belongs_to :project
	acts_as_paranoid
end
