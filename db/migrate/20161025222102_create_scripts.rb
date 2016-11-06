class CreateScripts < ActiveRecord::Migration
  def change
    create_table :scripts do |t|
      t.string :name
      t.timestamps null: false
    end
    add_reference :scripts, :project

    add_column :scripts, :deleted_at, :datetime
    add_index :scripts, :deleted_at
  end
end
