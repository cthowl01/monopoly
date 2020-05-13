class CreateUserGames < ActiveRecord::Migration[5.2]
  def change
    create_table :user_games do |t|
      t.integer :game_id
      t.integer :user_id
      t.integer :position, default: 0
      t.integer :previous_position, default: 0
      t.integer :num_moves, default: 0
      t.integer :balance, default: 30
      t.string :piece, default: "car_piece.png"
      t.boolean :jail, default: false
      t.integer :last_roll, array: true, default: []
      t.boolean :show_roll, default: true
      t.boolean :show_buttons, default: false
      t.integer :num_double_rolls, default: 0
      t.integer :num_jail_escape_rolls, default: 0

      t.timestamps
    end
  end
end
