class AddBalancesToGame < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :player_1_balance, :integer, default: 30
    add_column :games, :player_2_balance, :integer, default: 30
  end
end
