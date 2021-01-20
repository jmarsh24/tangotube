require 'sidekiq/web'

Rails.application.routes.draw do
  resources :search_suggestions
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  devise_for :users

  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  root 'videos#index'

  post 'savenew', to: 'users#savenew'

  get '/watch',    to: 'watch#show'
  get '/privacy',  to: 'static_pages#privacy'
  get '/terms',    to: 'static_pages#terms'

  resources :videos
  resources :channels
  resources :search_suggestions, only: :index
  namespace :admin do
    resources :users
  end
end
