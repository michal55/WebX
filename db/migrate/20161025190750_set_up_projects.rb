class SetUpProjects < ActiveRecord::Migration
  def change
    add_reference :projects, :user

    add_column :projects, :deleted_at, :datetime
    add_index :projects, :deleted_at
  end
end
