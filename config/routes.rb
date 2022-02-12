require 'sidekiq/web'

Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks',
                                    confirmations: 'confirmations',
                                    registrations: 'registrations' }

  resources :deletion_requests, only: [:show] do
    collection do
      post :facebook
    end
  end

  devise_scope :user do
    authenticate :user, -> (u) { u.admin? } do
      mount Sidekiq::Web, at: 'sidekiq', as: :sidekiq
    end
  end

  root 'videos#index'

  post 'savenew', to: 'users#savenew'
  get '/watch', to: 'videos#show'
  get '/privacy', to: 'static_pages#privacy'
  get '/terms', to: 'static_pages#terms'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'

  resources :channels, only: %i[index create]
  resources :playlists, only: %i[index create]
  resources :videos, except: :show do
    member do
      patch "upvote", to: "videos#upvote"
      patch "downvote", to: "videos#downvote"
    end
  end
  resources :search_suggestions, only: :index
  resources :leaders, only: %i[index create]
  resources :followers, only: %i[index create]
  resources :events, only: %i[index create]
  resources :songs, only: :index
end
