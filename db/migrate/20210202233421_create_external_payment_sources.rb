class CreateExternalPaymentSources < ActiveRecord::Migration[6.0]
  def change
    create_table :external_payment_sources do |t|
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
