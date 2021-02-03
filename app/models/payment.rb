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

  after_create :create_feed

  private

  def create_feed
    feed_description = I18n.t('api.models.feeds.description', user: sender.username,
                                                              friend: receiver.username,
                                                              timestamp: created_at,
                                                              description: description)
    Feed.create!(payment: self, description: feed_description)
  end
end
