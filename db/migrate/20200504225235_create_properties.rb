class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.integer :game_id
      t.string :name
      t.string :color
      t.integer :holdfasts, default: 0
      t.integer :castles, default: 0
      t.boolean :mortgaged, default: false
      t.integer :cost, default: 0
      t.integer :mortgage_cost, default: 0

      t.timestamps
    end
  end
end
