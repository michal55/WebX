class AddMissingDeleteAtFlags < ActiveRecord::Migration
  def change
    add_column :frequencies, :deleted_at, :datetime
    add_index :frequencies, :deleted_at

    add_column :extraction_data, :deleted_at, :datetime
    add_index :extraction_data, :deleted_at

    add_column :extractions, :deleted_at, :datetime
    add_index :extractions, :deleted_at
  end
end
