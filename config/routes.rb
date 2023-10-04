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

  resource :manifest, only: :show

  get "dancers/top", to: "dancers#top_dancers", as: "top_dancers"
  get "orchestras/top", to: "orchestras#top_orchestras", as: "top_orchestras"
  get "events/top", to: "events#top_events", as: "top_events"
  get "songs/top", to: "songs#top_songs", as: "top_songs"

  resources :videos do
    member do
      get :details
      get :share
      get :watched_by_current_user, to: "watchers#has_been_watched"
      post :hide
      post :process_metadata
    end
    collection do
      get :filters
      get :sort
    end
  end

  get "watch", to: "watches#show", as: "watch"

  resources :video_sections, only: [] do
    collection do
      get :recent
      get :older
      get :trending
      get :performances
      get :event
      get :alternative
      get :dancer
      get :song
      get :orchestra
      get :channel
      get :interview
      get :workshop
      get :mundial
      get :dancer_song
    end
  end

  resources :songs do
    resource :lyrics, only: [:show]
  end

  resources :facets, only: :show

  resources :related_videos, only: [:show]

  resources :likes, only: [:create, :destroy]
  resources :features, only: [:create, :destroy]

  resources :files, only: :show, controller: "shimmer/files"

  namespace :webhooks do
    match :youtube, via: [:get, :post]
    post :patreon

    namespace :facebook do
      post :data_deletion, to: "#facebook_user_deletion"
    end
  end

  resources :recent_searches, only: [:index, :create, :destroy]

  resource :search, only: [:new, :show]

  namespace :search do
    resources :dancers, only: [:index]
    resources :songs, only: [:index]
    resources :videos, only: [:index]
    resources :orchestras, only: [:index]
    resources :couples, only: [:index]
    resources :events, only: [:index]
    resources :channels, only: [:index]
  end

  # Sitemap and Banner routes
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "banner", to: "banner#index"
  post "banner", to: "banner#index"
  get "support_us", to: "support#show"

  root "videos#index"
end
