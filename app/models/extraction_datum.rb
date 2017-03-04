class ExtractionDatum < ActiveRecord::Base
  belongs_to :instance
  acts_as_paranoid
end
