class CreateGames < ActiveRecord::Migration[5.2]
  def change
    create_table :games do |t|
      t.string :title
      t.integer :player_1_id
      t.integer :player_2_id
      t.string :current_status
      t.string :current_user
      t.integer :result
      t.integer :turn_player_id

      t.timestamps
    end
  end
end
