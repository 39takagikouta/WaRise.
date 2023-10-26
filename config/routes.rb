Rails.application.routes.draw do
  root 'tops#top'
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  resources :users, only: %i[show]
  get 'toggle_display', to: 'users#toggle_display'
  resources :preferences, only: %i[new create edit update]
  resources :alarms, only: %i[new create edit update destroy index]
  get 'mypage', to: 'alarms#mypage'
  get 'recommend', to: 'alarms#recommend'
  resources :viewed_videos, only: %i[create]
  resources :likes, only: [:create, :destroy]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
