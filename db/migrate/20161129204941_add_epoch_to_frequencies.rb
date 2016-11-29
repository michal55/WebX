class AddEpochToFrequencies < ActiveRecord::Migration
  def change
    add_column :frequencies, :epoch, :integer
    add_column :frequencies, :last_run, :datetime
  end
end
