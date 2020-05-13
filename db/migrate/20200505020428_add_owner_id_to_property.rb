class AddOwnerIdToProperty < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :owner_id, :integer, default: 0
    add_column :properties, :div_id, :integer, default: 0
    add_column :properties, :property_type, :string, default: "regular"
    add_column :properties, :houses, :integer, default: 0
    add_column :properties, :hotels, :integer, default: 0
  end
end
