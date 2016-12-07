class RenameDataschemaToDataField < ActiveRecord::Migration
  def change
    rename_table :data_schemas, :data_fields
  end
end
