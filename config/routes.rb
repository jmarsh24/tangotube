# frozen_string_literal: true

require "sidekiq/web"
require "sidekiq-scheduler/web"

Rails.application.routes.draw do
  get "up" => "rails/health#show", :as => :rails_health_check

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all

  authenticate :user, ->(user) { user.admin? } do
    mount Avo::Engine, at: Avo.configuration.root_path
  end
  get "sitemaps/*path", to: "shimmer/sitemaps#show"
  get "status", to: "system_status#show"
  get "banner", to: "banner#index"
  post "banner", to: "banner#index"

  devise_for :users, controllers: {
    omniauth_callbacks: "users/omniauth_callbacks",
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

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

  resources :playlists, only: [:index, :create]
  resource :manifest, only: :show
  resources :videos do
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
  post "savenew", to: "users#savenew"
  post "/" => "videos#index"
  get "/watch", to: "videos#show"
  get "/privacy", to: "pages#privacy"
  get "/terms", to: "pages#terms"
  get "/about", to: "pages#about"
  get "/contact", to: "pages#contact"
  root "videos#index"
end
