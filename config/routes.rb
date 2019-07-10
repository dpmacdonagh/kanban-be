Rails.application.routes.draw do
  resources :users
  resources :projects do
    resources :todos
  end
end
