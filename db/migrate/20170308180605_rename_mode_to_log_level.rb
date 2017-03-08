class RenameModeToLogLevel < ActiveRecord::Migration
  def change
    remove_column :scripts, :mode
    add_column :scripts, :log_level, :integer
  end
end
