module Api
  module V1
    module Users
      class PaymentsController < Api::V1::ApiController
        def create
          PaymentService.new(current_user,
                             friend,
                             payment_params[:amount],
                             payment_params[:description]).transfer_money

          head :ok
        end

        private

        def payment_params
          params.require(:payment).permit(:amount, :description, :friend_id)
        end

        def current_user
          @current_user ||= User.find(params[:user_id])
        end

        def friend
          @friend ||= User.find(payment_params[:friend_id])
        end
      end
    end
  end
end
