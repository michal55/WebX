class ExtractionDatum < ActiveRecord::Base
  belongs_to :extraction
  acts_as_paranoid
end
