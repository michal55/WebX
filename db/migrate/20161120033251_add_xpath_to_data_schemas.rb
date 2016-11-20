class AddXpathToDataSchemas < ActiveRecord::Migration
  def change
    add_column :data_schemas, :xpath, :string
  end
end
