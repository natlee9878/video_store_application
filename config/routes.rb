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
  resources :videos, only: [:index, :show, :new, :create]
  get '/index',to: 'users#index'
  get '/new', to: 'videos#new'
  get 'search', to: 'videos#search', as: :search
  get '/logout',  to: 'sessions#delete'
  get 'admin_dashboard_users', to: 'admin#dashboard'
  delete '/logout', to: 'sessions#destroy'
end
