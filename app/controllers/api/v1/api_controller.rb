module Api
  module V1
    class ApiController < ActionController::API
      rescue_from ActiveRecord::RecordNotFound,        with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid,         with: :render_record_invalid
      rescue_from ActionController::ParameterMissing,  with: :render_parameter_missing
      rescue_from Payments::NotUsersFriendshipError,   with: :render_request_invalid
      rescue_from Payments::NegativeAmountError,       with: :render_request_invalid

      def status
        render json: { online: true }
      end

      private

      def render_not_found(exception)
        logger.info { exception } # for logging
        render json: { error: I18n.t('api.errors.not_found') }, status: :not_found
      end

      def render_record_invalid(exception)
        logger.info { exception } # for logging
        render json: { errors: exception.record.errors.as_json }, status: :bad_request
      end

      def render_parameter_missing(exception)
        logger.info { exception } # for logging
        render json: { error: I18n.t('api.errors.missing_param') }, status: :unprocessable_entity
      end

      def render_request_invalid(exception)
        logger.info { exception }
        render json: { errors: exception.message }, status: :bad_request
      end
    end
  end
end
