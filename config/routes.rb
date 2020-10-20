Rails.application.routes.draw do
 
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users
  
  root "videos#index"

  post 'savenew', to: 'users#savenew'

  resources :videos
  
  namespace :admin do
    resources :users
  end
  
end
