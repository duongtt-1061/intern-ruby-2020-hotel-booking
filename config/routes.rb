Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: "omniauth_callbacks" }
  scope "(:locale)", locale: /en|vi/ do
    root to: "static_pages#home"

    require "sidekiq/web"
    mount Sidekiq::Web => "/sidekiq"

    get "/categories/:slug/rooms", to: "rooms#index"
    get "/room/:slug", to: "rooms#show", as: "room"
    get "/login", to: "sessions#new"
    post "/login", to: "sessions#create"
    delete "/logout", to: "sessions#destroy"
    get "/search", to: "search#index"
    get "categories", to: "categories#index"
    post "check_room", to: "bookings#check_room"
    resources :orders

    namespace :admins do
      root to: "orders#index"
      resources :rooms
      resources :orders
    end
  end
end
