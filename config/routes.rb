Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'videos#index'

  post 'savenew', to: 'users#savenew'

  get 'watch', to: 'watch#watch'

  resources :videos

  namespace :admin do
    resources :users
  end
end
