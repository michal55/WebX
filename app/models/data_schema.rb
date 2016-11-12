class DataSchema < ActiveRecord::Base
  belongs_to :project

  acts_as_paranoid
  enum sentiment_final_class: {unavailable: 0, undecidable: 1, negative: 2, positive: 3 }

end
