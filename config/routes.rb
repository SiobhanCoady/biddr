Rails.application.routes.draw do

  resources :auctions, only: [:index, :new, :create, :show, :update] do
    resources :bids, only: :create
  end

  resources :users, only: [:new, :create]

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  root 'auctions#index'
end
