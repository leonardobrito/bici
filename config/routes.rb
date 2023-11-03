# frozen_string_literal: true

require "sidekiq/web"

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ("/")
  root "welcome#index"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  mount Sidekiq::Web => "/sidekiq"
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  get "/public_method", to: "hello_world#public_method"
  get "/private_method", to: "hello_world#private_method"
  get "/search", to: "hello_world#search"
end
