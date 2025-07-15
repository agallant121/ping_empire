require "sidekiq/web"
require "action_dispatch/middleware/session/cookie_store"

Sidekiq::Web.use ActionDispatch::Cookies
Sidekiq::Web.use ActionDispatch::Session::CookieStore, key: "_your_app_session"

Rails.application.routes.draw do
  devise_for :users
  mount Sidekiq::Web => "/sidekiq"

  namespace :api do
    namespace :v1 do
      resources :websites, only: [:create, :index, :show, :destroy]
    end
  end
end
