Rails.application.routes.draw do
  resources :alarms, only: %i[new create edit update destroy]
  get 'mypage', to: 'alarms#mypage'
  devise_for :users
  root 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
