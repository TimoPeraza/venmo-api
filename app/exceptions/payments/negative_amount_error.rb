module Payments
  class NegativeAmountError < StandardError
    def initialize(msg = I18n.t('api.errors.payments.negative_amount'))
      super
    end
  end
end
