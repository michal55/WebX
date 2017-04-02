class RemoveEpochFromFrequency < ActiveRecord::Migration
  def change
    remove_column :frequencies, :epoch
  end
end
