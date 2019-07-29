Rails.application.routes.draw do
  resources :users do
    collection do
      get 'current'
    end
  end
  resources :boards do
    resources :cards
  end
end
