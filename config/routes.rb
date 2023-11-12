Rails.application.routes.draw do
  root 'tops#top'
  get 'terms_of_use', to: 'tops#terms_of_use'
  get 'privacy_policy', to: 'tops#privacy_policy'
  devise_for :users, controllers: {
    omniauth_callbacks: "omniauth_callbacks"
  }, skip: [:sessions, :registrations]
  devise_scope :user do
    get 'users/edit', to: 'devise/registrations#edit', as: :edit_user_registration
    put 'users', to: 'devise/registrations#update', as: :user_registration
    delete 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
    delete 'users', to: 'devise/registrations#destroy', as: :destroy_user_registration
  end
  resources :users, only: %i[show]
  get 'toggle_display', to: 'users#toggle_display'
  resources :preferences, only: %i[new create edit update]
  resources :alarms, only: %i[new create edit update destroy index]
  get 'mypage', to: 'alarms#mypage'
  get 'recommend', to: 'alarms#recommend'
  get 'ranking', to: 'alarms#ranking'
  resources :viewed_videos, only: %i[create]
  resources :likes, only: [:create, :destroy]


  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
