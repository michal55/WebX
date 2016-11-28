class AddLastRunToScripts < ActiveRecord::Migration
  def change
    add_column :scripts, :last_run, :datetime
  end
end
