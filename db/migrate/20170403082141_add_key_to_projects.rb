class AddKeyToProjects < ActiveRecord::Migration
  def change
    add_column :users, :api_key, :string
    users = User.all
    users.each do |u|
      u.api_key = rand(36**20).to_s(36)
      u.save!
    end
  end
end
