Rails.application.routes.draw do

  resources :auctions

  root 'auctions#index'
end
