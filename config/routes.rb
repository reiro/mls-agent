Rails.application.routes.draw do
  devise_for :users

  # root to: 'home#index'

  resources :agent_rooms, only: [:new, :create, :show, :index]
  resources :listings, only: [:index, :show]
  get '/start' => 'agent_rooms#start'
  root 'agent_rooms#index'

  mount ActionCable.server => '/cable'
end
