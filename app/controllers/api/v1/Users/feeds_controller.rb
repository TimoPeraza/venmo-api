module Api
  module V1
    module Users
      class FeedsController < Api::V1::ApiController
        def index
          @feeds = FeedService.new(current_user).list.page(page_number)
        end

        private

        def current_user
          @current_user ||= User.find(params[:user_id])
        end

        def page_number
          params[:page] || 1
        end
      end
    end
  end
end
