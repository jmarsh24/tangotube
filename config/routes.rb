require 'sidekiq/web'

Rails.application.routes.draw do
  get "checkout", to: "checkouts#show"
  get "billing", to: "billing#show"

  get 'errors/not_found'
  get 'errors/internal_server_error'

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    confirmations: 'users/confirmations',
                                    registrations: 'users/registrations' }

  resources :deletion_requests, only: [:show] do
    collection do
      post :facebook
    end
  end

  devise_scope :user do
    authenticate :user, -> (u) { u.admin? } do
      mount Sidekiq::Web, at: 'sidekiq', as: :sidekiq
      resources :channels
    end
  end

  resources :comments do
    resources :comments, module: :comments
  end

  resources :playlists, only: %i[index create]
  resources :clips, only: %i[index]
  resources :videos do
    collection do
      post :index
    end
    resources :clips
    resources :comments, module: :videos
    member do
      patch "upvote", to: "videos#upvote"
      patch "downvote", to: "videos#downvote"
      patch "bookmark", to: "videos#bookmark"
      patch "complete", to: "videos#complete"
      patch "watchlist", to: "videos#watchlist"
      patch "featured", to: "videos#featured"
    end
  end

  resources :search_suggestions, only: :index do
    collection do
      post :search
    end
  end

  resources :leaders, only: %i[index create]
  resources :followers, only: %i[index create]
  resources :events, only: %i[index create]
  resources :songs, only: :index

  get "filters", to: "filters#filters"
  get "filters/leader", to: "filters#leader"
  get "filters/follower", to: "filters#follower"
  get "filters/year", to: "filters#year"
  get "filters/genre", to: "filters#genre"

  root 'videos#index'
  post '/' => 'videos#index'
  post 'savenew', to: 'users#savenew'
  get '/watch', to: 'videos#show'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
end
