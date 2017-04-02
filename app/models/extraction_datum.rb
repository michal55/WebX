class ExtractionDatum < ActiveRecord::Base
  belongs_to :instance
  belongs_to :extraction
  acts_as_paranoid
end
