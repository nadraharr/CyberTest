# frozen_string_literal: true

Rails.application.routes.draw do
  root 'pages#index'
  post '/submit', to: 'pages#getgit'
  post '/nextpage', to: 'pages#next_page'
  post '/prevpage', to: 'pages#prev_page'
  mount GraphiQL::Rails::Engine, at: '/graphiql', graphql_path: '/graphql' if Rails.env.development?
  post '/graphql', to: 'graphql#execute'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
