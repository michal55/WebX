class InitializeElastic < ActiveRecord::Migration
  def change
    Log.create_index!
  end
end



