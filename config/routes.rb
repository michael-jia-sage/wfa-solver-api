# config/routes.rb
Rails.application.routes.draw do
  resources :caltest
  resources :solve
  resources :wesage
  resources :callback, only: [:index] do
    collection do
      get 'success'
    end
  end
  resources :auth, only: [:index]
end