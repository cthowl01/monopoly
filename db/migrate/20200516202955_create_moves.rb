class CreateMoves < ActiveRecord::Migration[5.2]
  def change
    create_table :moves do |t|
      t.integer :game_id
      t.string :summary

      t.timestamps
    end
  end
end
