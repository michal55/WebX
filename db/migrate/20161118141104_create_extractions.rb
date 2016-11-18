class CreateExtractions < ActiveRecord::Migration
  def change
    create_table :extractions do |t|

      t.timestamps null: false
    end
    add_reference :extractions, :script
  end
end
