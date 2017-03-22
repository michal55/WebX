class AddDeletedAtToInstances < ActiveRecord::Migration
  def change
    add_column :instances, :deleted_at, :datetime
    add_index :instances, :deleted_at
  end
end
