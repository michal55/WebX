class ChangeReferenceInExtractionData < ActiveRecord::Migration
  def change
    remove_reference :extraction_data, :extraction
    add_reference :extraction_data, :instance
  end
end
