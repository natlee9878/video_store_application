Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'pages#welcome'

  namespace :admin do
    resources :videos do
      collection do
        get :search
      end
    end
    resources :actors
    resources :stocks
    resources :actor_videos, only: [:edit, :update, :destroy]
    resources :genres
    resources :users
    resources :rentals
    resources :notifications
    resources :super_users
  end

  get '/home', to: 'pages#welcome'
  get '/cleanup_dropzone_upload', to: 'application#cleanup_dropzone_upload', as: :cleanup_dropzone_upload
  get '/index',to: 'users#index'
  get '/new', to: 'videos#new'
  get 'search', to: 'videos#search', as: :search
  get 'admin_dashboard', to: 'admin#dashboard'
  patch 'users/:id/update_role', to: 'users#update_role', as: 'update_role_user'
  delete '/logout', to: 'sessions#destroy', as: :logout
end
