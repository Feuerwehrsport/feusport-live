# frozen_string_literal: true

Rails.application.routes.draw do
  root 'home#home'
  get 'info', to: 'home#info', as: :info

  devise_for :users, controllers: {
    registrations: 'users/registrations',
  }

  resources :competitions, only: %i[new create index]
  scope '/:year/:slug', constraints: { year: /(\d{4})/ }, module: :competitions, as: :competition do
    root 'showings#show', as: :show
    resource :editing, only: %i[edit update]
    resource :visibility, only: %i[edit update]
    resource :deletion, only: %i[new create]
    resources :documents, only: %i[new create edit update destroy]

    # top menu
    resources :teams
    resources :people
    resources :score_lists

    # wrench menu
    resources :disciplines
    resources :bands
    resources :assessments
  end
end
