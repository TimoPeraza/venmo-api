module Payments
  class NotUsersFriendshipError < StandardError
    def initialize(msg = I18n.t('api.errors.payments.not_users_friendship'))
      super
    end
  end
end
