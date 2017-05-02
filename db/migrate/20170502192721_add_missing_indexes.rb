class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :scripts, :id
    add_index :projects, :id
    add_index :extractions, :id
    add_index :extractions, :script_id
    add_index :extractions, :created_at
    add_index :instances, :id
    add_index :instances, :extraction_id
    add_index :instances, :created_at
    add_index :instances, :is_leaf
  end
end
