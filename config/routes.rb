require 'sidekiq/web'

Rails.application.routes.draw do
  resources :events
  resources :playlists
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  namespace :admin do
    resources :users
  end

  devise_for :users

  authenticate :admin_user do
    mount Sidekiq::Web => '/admin/sidekiq'
  end

  root 'videos#index'

  post 'savenew', to: 'users#savenew'

  get '/watch',    to: 'watch#show'
  get '/privacy',  to: 'static_pages#privacy'
  get '/terms',    to: 'static_pages#terms'
  get '/about',    to: 'static_pages#about'

  resources :videos
  resources :channels
  resources :playlists
  resources :search_suggestions, only: :index
end
