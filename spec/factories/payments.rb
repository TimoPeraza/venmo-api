# == Schema Information
#
# Table name: payments
#
#  id          :bigint           not null, primary key
#  sender_id   :bigint           not null
#  receiver_id :bigint           not null
#  amount      :float            not null
#  description :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  index_payments_on_receiver_id  (receiver_id)
#  index_payments_on_sender_id    (sender_id)
#
FactoryBot.define do
  factory :payment do
    sender   factory: :user
    receiver factory: :user
    amount { Faker::Number.decimal(l_digits: 3) }
    description { Faker::Lorem.sentence }
  end
end
