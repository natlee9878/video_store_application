Rails.application.routes.draw do
  devise_for :users
  scope '/admin' do
    resources :users
  end
  resources :users do
    collection do
      get '/admin', to: 'admin#dashboard'
    end
  end
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'videos#index'
  resources :videos, only: [:index, :show, :new, :create, :edit, :update, :destroy]
  get '/index',to: 'users#index'
  get '/new', to: 'videos#new'
  get 'search', to: 'videos#search', as: :search
  get '/logout',  to: 'sessions#delete'
  get 'admin_dashboard_users', to: 'admin#dashboard'
  patch 'users/:id/update_role', to: 'users#update_role', as: 'update_role_user'
  delete '/logout', to: 'sessions#destroy'
end
