class FeedsQuery
  attr_reader :users_ids

  def initialize(users_ids)
    @users_ids = users_ids
  end

  def feeds
    feed_joins_payment = Feed.joins(:payment)

    feed_joins_payment.where(payments: { sender_id: users_ids })
                      .or(feed_joins_payment.where(payments: { receiver_id: users_ids }))
                      .order(created_at: :desc)
  end
end
