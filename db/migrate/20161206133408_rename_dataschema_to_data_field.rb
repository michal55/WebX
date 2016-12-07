class RenameDataschemaToDataField < ActiveRecord::Migration
  def change
    rename_table :data_fields, :data_fields
  end
end
