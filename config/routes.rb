# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
  end
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "banner", to: "banner#index"
  post "banner", to: "banner#index"

  devise_for :users, controllers: {omniauth_callbacks: "users/omniauth_callbacks",
                                   confirmations: "users/confirmations",
                                   registrations: "users/registrations"}

  resources :deletion_requests, only: [:show] do
    collection do
      post :facebook
    end
  end

  devise_scope :user do
    authenticate :user, ->(u) { u.admin? } do
      mount Sidekiq::Web, at: "sidekiq", as: :sidekiq
      resources :channels do
        post "deactivate", to: "channels#deactivate"
      end
    end
  end

  resources :comments do
    resources :comments, module: :comments
  end

  resources :playlists, only: %i[index create]
  resources :clips do
    collection do
      post :index
    end
  end
  resources :couples do
    collection do
      post :index
    end
    member do
      post :show
    end
  end
  resources :orchestras do
    collection do
      post :index
    end
    member do
      post :show
    end
  end
  resources :performances do
    collection do
      post :index
    end
  end
  resource :manifest, only: :show
  resources :videos do
    collection do
      post :index
    end
    resources :clips
    collection do
      get "filters", to: "filters#filters"
    end
    resources :comments, module: :videos
    member do
      patch "upvote", to: "videos#upvote"
      patch "downvote", to: "videos#downvote"
      patch "bookmark", to: "videos#bookmark"
      patch "complete", to: "videos#complete"
      patch "watchlist", to: "videos#watchlist"
      patch "featured", to: "videos#featured"
      post "hide", to: "videos#hide"
    end
  end

  resources :webhooks

  resources :search_suggestions, only: :index do
    collection do
      post :search
    end
  end

  resources :dancers do
    member do
      post :show
    end
  end
  resources :events do
    collection do
      post :index
    end
    member do
      post :show
    end
  end
  resources :songs do
    collection do
      post :index
    end
    member do
      post :show
    end
  end

  post "savenew", to: "users#savenew"
  post "/" => "videos#index"
  get "/watch", to: "videos#show"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  root "videos#index"
end
