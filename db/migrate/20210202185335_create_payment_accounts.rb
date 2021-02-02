class CreatePaymentAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :payment_accounts do |t|
      t.references :user, foreign_key: true, null: false
      t.float :balance, null: false, default: 0

      t.timestamps
    end
  end
end
