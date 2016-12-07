class AddReferenceToDataSchema < ActiveRecord::Migration
  def change
    add_reference :data_schemas, :project

    add_column :data_schemas, :deleted_at, :datetime
    add_index :data_schemas, :deleted_at
  end
end
