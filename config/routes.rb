# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  # Health checks
  get "up" => "rails/health#show", :as => :rails_health_check
  get "status", to: "system_status#show"

  # Error routes
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # User Authentication
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # Admin section
  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
    mount Sidekiq::Web, at: "sidekiq", as: :sidekiq
    resources :channels do
      post "deactivate", to: "channels#deactivate"
    end
  end

  # Public pages
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"

  # Main resources
  resources :dancers, :events, :songs, only: [:index, :show] do
    member do
      post :show
    end
    collection do
      post :index
    end
  end

  resource :manifest, only: :show

  resources :videos do
    resources :clips, :comments, module: :videos
    get "filters", to: "videos/filters#index", on: :collection
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
  resources :facets, only: :show

  resources :playlists, :clips, :couples, :orchestras, :performances, only: [:index, :show, :create] do
    member do
      post :show
    end
    collection do
      post :index
    end
  end

  resources :webhooks, :search_suggestions, only: [:index] do
    collection do
      post :search
    end
  end

  resources :deletion_requests, only: [:show] do
    collection do
      post :facebook
    end
  end

  # Other routes
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "banner", to: "banner#index"
  post "banner", to: "banner#index"
  post "savenew", to: "users#savenew"
  get "/watch", to: "videos#show"

  # Root
  root "videos#index"
end
