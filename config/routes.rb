Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  require "sidekiq/web"
  mount Sidekiq::Web => '/sidekiq'

  root "videos#index"

  post "savenew", to: "users#savenew"

  resources :videos

  namespace :admin do
    resources :users
  end
end
