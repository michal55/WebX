class Project < ActiveRecord::Base
  has_many :script
  has_many :data_schemas
  belongs_to :user

  acts_as_paranoid

end
