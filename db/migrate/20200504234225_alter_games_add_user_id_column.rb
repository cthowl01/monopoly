class AlterGamesAddUserIdColumn < ActiveRecord::Migration[5.2]
  def change
    add_column :games, :user_id, :integer
    add_index :games, :user_id
    add_column :games, :firebase_id, :string
  end
end
