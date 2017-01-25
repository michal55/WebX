class AddReferenceToDataSchema < ActiveRecord::Migration
  def change
    add_reference :data_fields, :project

    add_column :data_fields, :deleted_at, :datetime
    add_index :data_fields, :deleted_at
  end
end
