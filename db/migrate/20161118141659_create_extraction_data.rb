class CreateExtractionData < ActiveRecord::Migration
  def change
    create_table :extraction_data do |t|
      t.string :field_name
      t.string :value

      t.timestamps null: false
    end
    add_reference :extraction_data, :extraction
  end
end
