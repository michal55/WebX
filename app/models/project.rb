class Project < ActiveRecord::Base
  has_many :script
  has_many :data_schemas
  belongs_to :user

  acts_as_paranoid

  enum sentiment_final_class: {string: 0, integer: 1, float: 2}

end
