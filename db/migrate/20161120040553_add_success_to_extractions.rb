class AddSuccessToExtractions < ActiveRecord::Migration
  def change
    add_column :extractions, :success, :boolean
    add_column :extractions, :execution_time, :float
  end
end
