class InitializeElastic < ActiveRecord::Migration
  def change
    Log.create_index! force: true
  end
end



