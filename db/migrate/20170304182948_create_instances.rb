class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|

      t.timestamps null: false
    end
    add_reference :instances, :extraction
  end
end
