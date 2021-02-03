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
class Payment < ApplicationRecord
  belongs_to :sender, class_name: 'User'
  belongs_to :receiver, class_name: 'User'

  has_one :feed, dependent: :destroy

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: 0,
                                     less_than_or_equal_to: 1000 }
end
