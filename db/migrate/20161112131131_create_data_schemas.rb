class CreateDataSchemas < ActiveRecord::Migration
  def change
    create_table :data_fields do |t|

      t.timestamps null: false
      t.string :name
      t.integer :data_type
    end
  end
end
