Rails.application.routes.draw do
  root 'tops#top'
  get 'terms_of_use', to: 'tops#terms_of_use'
  get 'privacy_policy', to: 'tops#privacy_policy'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    omniauth_callbacks: "omniauth_callbacks"
  }
  resources :users, only: %i[show]
  get 'toggle_display', to: 'users#toggle_display'
  resources :preferences, only: %i[new create edit update]
  resources :alarms, only: %i[new create edit update destroy index]
  get 'mypage', to: 'alarms#mypage'
  get 'recommend', to: 'alarms#recommend'
  get 'ranking', to: 'alarms#ranking'
  resources :alarms_forms, only: %i[new create]
  resources :viewed_videos, only: %i[create]
  resources :likes, only: [:create, :destroy]
  post '/callback', to: 'hoges#callback'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
