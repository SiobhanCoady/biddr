Rails.application.routes.draw do

  resources :auctions, shallow: true, only: [:index, :new, :create, :show, :update] do
    resources :bids, only: :create
    resources :trackings, only: [:create, :destroy]
    get :with_bids, on: :collection
  end

  resources :users, only: [:new, :create, :show] do
    resources :trackings, only: [:index]
  end

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  root 'auctions#index'
end
