class CreateDataSchemas < ActiveRecord::Migration
  def change
    create_table :data_schemas do |t|

      t.timestamps null: false
      t.string :name
      t.integer :data_type
    end
  end
end
