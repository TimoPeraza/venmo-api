class CreateFriendships < ActiveRecord::Migration[6.0]
  def change
    create_table :friendships do |t|
      t.references :first_friend, foreign_key: { to_table: :users }, null: false
      t.references :second_friend, foreign_key: { to_table: :users }, null: false

      t.timestamps
    end

    add_index :friendships, [:first_friend_id, :second_friend_id], unique: true
  end
end
