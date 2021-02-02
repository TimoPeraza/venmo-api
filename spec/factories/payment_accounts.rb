# == Schema Information
#
# Table name: payment_accounts
#
#  id         :bigint           not null, primary key
#  user_id    :bigint           not null
#  balance    :float            default(0.0), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_payment_accounts_on_user_id  (user_id)
#
FactoryBot.define do
  factory :payment_account do
    user
    balance { 500 }
  end
end
