class AddOwnerIdToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :owner_id, :integer, default: 0
  end
end
