class AddXpathsToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :xpaths, :json
  end
end
