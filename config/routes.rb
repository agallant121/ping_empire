Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  mount Sidekiq::Web => "/sidekiq"
  
  namespace :api do
    namespace :v1 do
      resources :websites, only: [:create, :index, :show, :destroy]
    end
  end
end
