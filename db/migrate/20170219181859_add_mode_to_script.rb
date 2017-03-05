class AddModeToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :mode, :integer
  end
end
