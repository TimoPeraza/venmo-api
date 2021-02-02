Rails.application.routes.draw do
  namespace :api do
    namespace :v1, defaults: { format: :json } do
      get :status, to: 'api#status'

      resources :users, only: [] do
        scope module: 'users' do
          resource :balance, only: :show
        end
      end
    end
  end
end
