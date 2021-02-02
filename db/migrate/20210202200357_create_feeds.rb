class CreateFeeds < ActiveRecord::Migration[6.0]
  def change
    create_table :feeds do |t|
      t.references :payment, foreign_key: true, null: false
      t.string :description, null: false

      t.timestamps
    end
  end
end
