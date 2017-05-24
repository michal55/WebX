class AddRetriesToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :retries, :integer
    add_column :scripts, :retries_left, :integer
  end
end
