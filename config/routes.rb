Rails.application.routes.draw do
  devise_for :users

  # root to: 'home#index'

  resources :agent_rooms, only: [:new, :create, :show, :index]
  root 'agent_rooms#index'

  mount ActionCable.server => '/cable'
end
