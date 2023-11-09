Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'admin#dashboard'

  namespace :admin do
    resources :videos
    resources :actors
    resources :stocks
    resources :actor_videos, only: [:edit, :update, :destroy]
    resources :genres
    resources :users
    resources :rentals
    resources :notification_request
  end


  get '/cleanup_dropzone_upload', to: 'application#cleanup_dropzone_upload', as: :cleanup_dropzone_upload
  get '/index',to: 'users#index'
  get '/new', to: 'videos#new'
  get 'search', to: 'videos#search', as: :search
  get '/logout',  to: 'sessions#delete'
  get 'admin_dashboard_users', to: 'admin#dashboard'
  patch 'users/:id/update_role', to: 'users#update_role', as: 'update_role_user'
  delete '/logout', to: 'sessions#destroy'
  get 'admin_dashboard', to: 'admin_dashboard#show', as: :admin_dashboard
  get 'actorlist', to: 'admin#actorlist'
  get 'userlist', to: 'admin#userlist'
  get 'videolist', to: 'admin#videolist'
  get 'rentallist', to: 'admin#rentallist'
  get 'new_video', to: 'videos#new'
  get 'new_user', to: 'users#new'
end
