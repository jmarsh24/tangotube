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
      get :details
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

  resources :songs do
    resource :lyrics, only: [:show]
  end

  resource :search, only: [:new, :show]

  # Facet route
  resources :facets, only: :show

  resources :related_videos, only: [:show]

  # Like routes
  resources :likes, only: [:create, :destroy]

  resources :files, only: :show, controller: "shimmer/files"

  match "/webhooks/youtube", to: "webhooks#youtube", via: [:get, :post]
  post "/webhooks/patreon", to: "webhooks#patreon"

  # Sitemap and Banner routes
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "banner", to: "banner#index"
  post "banner", to: "banner#index"
  get "support_us", to: "support#show"

  # Watch and root routes
  get "/watch", to: "videos#show", as: "watch"
  root "videos#index"
end
