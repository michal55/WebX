class AddUrlToScript < ActiveRecord::Migration
  def change
    add_column :scripts, :url, :string
  end
end
