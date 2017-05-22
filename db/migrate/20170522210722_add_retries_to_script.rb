class AddRetriesToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :retries, :integer
  end
end
