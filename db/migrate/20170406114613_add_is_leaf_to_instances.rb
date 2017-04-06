class AddIsLeafToInstances < ActiveRecord::Migration
  def change
    add_column :instances, :is_leaf, :boolean

    instance_ids = Instance.all
    instance_ids.each do |inst|
      references = Instance.where(parent_id: inst.id).count

      if references == 1
        references = 0 if Instance.where(parent_id: inst.id).first.id == inst.id
      end

      if references == 0
        inst.is_leaf = true
      else
        inst.is_leaf = false
      end
      inst.save!
    end
  end
end
