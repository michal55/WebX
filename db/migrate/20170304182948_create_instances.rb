class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|

      t.timestamps null: false
    end
    add_reference :instances, :extractions
  end
end
