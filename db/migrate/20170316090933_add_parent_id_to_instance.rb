class AddParentIdToInstance < ActiveRecord::Migration
  def change
    add_column :instances, :parent_id, :integer
  end
end
