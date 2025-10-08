# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Api::Engine => '/api-docs'
  mount Rswag::Ui::Engine => '/api-docs'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  namespace :api do
    namespace :v1 do
      devise_for :bibliotecarios, controllers: { passwords: 'bibliotecarios/passwords' }, skip: [:sessions, :registrations]
      resources :bibliotecarios, only: %i[show create update destroy]
      resource :sessions, only: %i[create destroy]
      resources :categorias, only: %i[index show create update destroy]
      resources :livros, only: %i[index show create update destroy]
      resources :usuarios, only: %i[index show create update destroy] do
      collection do
        get 'find_by_cpf/:cpf', to: 'usuarios#find_by_cpf', constraints: { cpf: /[0-9\.\-]+/ }
      end
      member do
        get :emprestimos
      end
    end
      resources :emprestimos, only: %i[index show create update destroy] do
        collection do
          get :atrasados
          post :renovar
        end
      end
      resources :multas, only: %i[index show update]
    end
  end
end
