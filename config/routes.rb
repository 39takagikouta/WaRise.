Rails.application.routes.draw do
  root 'tops#top'
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }
  resources :users, only: %i[show]
  resources :alarms, only: %i[new create edit update destroy]
  get 'mypage', to: 'alarms#mypage'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
