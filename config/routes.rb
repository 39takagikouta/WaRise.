Rails.application.routes.draw do
  resources :alarms, only: %i[new create edit update destroy]
  devise_for :users
  root 'home#index'
  get 'mypage', to: 'mypages#mypage'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
