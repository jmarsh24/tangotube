# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  # Health check routes
  get "up", to: "rails/health#show", as: :rails_health_check
  get "status", to: "system_status#show"

  # Error pages
  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  # Devise routes
  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # Admin routes
  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
    mount Sidekiq::Web, at: "sidekiq", as: :sidekiq
  end

  # Static pages
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"

  # Manifest route
  resource :manifest, only: :show

  # Video routes
  resources :videos do
    member do
      post :like
      delete :unlike
      post :hide
      patch :featured
      get :share
    end
    collection do
      get :filters
      get :sort
    end
  end

  resource :search, only: [:new, :show]

  # Facet route
  resources :facets, only: :show

  # Like routes
  resources :likes, only: [:create, :destroy]

  # Playlist, Clip, Couple, Orchestra, Performance routes
  resources :playlists, :clips, :couples, :orchestras, :performances, only: [:index, :show, :create]

  resources :files, only: :show, controller: "shimmer/files"

  # Webhook and Search Suggestion routes
  resources :webhooks, :search_suggestions, only: [:index] do
    collection do
      post :search
    end
  end

  # Sitemap and Banner routes
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "banner", to: "banner#index"
  post "banner", to: "banner#index"

  # Watch and root routes
  get "/watch", to: "videos#show"
  root "videos#index"
end
