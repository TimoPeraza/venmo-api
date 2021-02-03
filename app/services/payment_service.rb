class PaymentService
  attr_reader :user, :friend, :amount, :description

  def initialize(user, friend, amount, description)
    @user = user
    @friend = friend
    @amount = amount
    @description = description
  end

  def transfer_money
    validates_amount_is_positive!
    validates_friendship!
    external_funds if balance_negative?
    internal_funds_transaction
  end

  private

  def validates_amount_is_positive!
    raise Payments::NegativeAmountError if amount.negative?
  end

  def validates_friendship!
    raise Payments::NotUsersFriendshipError unless Friendship.exists_friendship(user, friend)
  end

  def internal_funds_transaction
    ActiveRecord::Base.transaction do
      Payment.create!(sender: user,
                      receiver: friend,
                      amount: amount,
                      description: description)
      user.payment_account.add_to_balance(-amount)
      friend.payment_account.add_to_balance(amount)
    end
  end

  def balance_negative?
    (user.payment_account_balance - amount).negative?
  end

  def external_funds
    user_payment_account = user.payment_account
    MoneyTransferService.new(user.external_payment_source, user_payment_account)
                        .transfer(amount - user_payment_account.balance)
  end
end
