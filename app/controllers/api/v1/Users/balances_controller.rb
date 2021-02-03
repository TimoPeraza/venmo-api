module Api
  module V1
    module Users
      class BalancesController < Api::V1::ApiController
        def show
          @payment_account = current_user.payment_account
        end

        private

        def current_user
          @current_user ||= User.find(params[:user_id])
        end
      end
    end
  end
end
