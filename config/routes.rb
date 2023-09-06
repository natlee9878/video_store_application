Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  root 'videos#index'
  resources :videos, only: [:index, :show, :new, :create]
  get '/new', to: 'videos#new'
  get 'search', to: 'videos#search', as: :search
end
