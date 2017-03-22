class AddExtractionToExtractionDatum < ActiveRecord::Migration
  def change
    add_reference :extraction_data, :extraction
  end
end
