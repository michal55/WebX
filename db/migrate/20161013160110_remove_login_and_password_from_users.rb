class RemoveLoginAndPasswordFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :login
    remove_column :users, :password
  end
end
