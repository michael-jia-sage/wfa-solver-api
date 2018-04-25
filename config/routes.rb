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
  resources :sage, only: [:index] do
    collection do
      get 'ledger_entries'
      post 'invoices'
    end
    # get 'ledger_entries'
  end
end