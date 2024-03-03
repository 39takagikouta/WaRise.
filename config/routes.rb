require 'sidekiq/web'
require 'sidekiq-scheduler/web'

Rails.application.routes.draw do
  root 'tops#top'
  get 'terms_of_use', to: 'tops#terms_of_use'
  get 'privacy_policy', to: 'tops#privacy_policy'
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    omniauth_callbacks: "omniauth_callbacks"
  }
  resources :users, only: %i[show]
  get 'toggle_display', to: 'users#toggle_display'
  resources :preferences, only: %i[new create edit update]
  resources :alarms, only: %i[new create edit update destroy index]
  get 'mypage', to: 'alarms#mypage'
  get 'day_alarms/:date', to: 'alarms#day_alarms', as: :day_alarms
  get 'alarm/:id/recommend', to: 'alarms#recommend', as: 'recommend_alarm'
  get 'ranking', to: 'alarms#ranking'
  resources :alarms_forms, only: %i[new create]
  resources :viewed_videos, only: %i[create]
  resources :likes, only: [:create, :destroy]
  post '/callback', to: 'webhooks#callback'

  # get '*path', to: 'application#render_404'

  Sidekiq::Web.use(Rack::Auth::Basic) do |user_id, password|
    [user_id, password] == [ENV.fetch('USER_ID', nil), ENV.fetch('USER_PASSWORD', nil)]
  end
  mount Sidekiq::Web, at: '/sidekiq'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
