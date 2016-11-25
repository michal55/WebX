class CreateFrequencies < ActiveRecord::Migration
  def change
    create_table :frequencies do |t|
      t.integer :interval
      t.string :period
      t.datetime :first_exec
      t.timestamps null: false
    end
    add_reference :frequencies, :script
  end
end
