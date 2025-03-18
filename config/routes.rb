Rails.application.routes.draw do
  resources :solutions
  get "companies/index"
  get "companies/show"
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }, path: "", path_names: { sign_up: "register" }

  namespace :admin do
    resources :featured_listings do
      collection do
        patch :update_positions
      end
      resources :featurable_items, only: [ :index, :create, :destroy ]
    end
    resources :companies
    resources :categories
    resources :tags, only: [ :new, :create ]
    get "dashboard", to: "dashboard#index"
    resources :users
    resources :companies
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  resources :companies, only: [ :index, :show ] do
    resources :solutions
  end
  root to: "pages#index"

  resources :technologies

  resources :companies do
    resource :company_technologies, only: [ :edit, :update ], path: "tech-stack"
  end

  # Tech stack search route
  get "companies/search/tech-stack", to: "companies#search_by_tech_stack", as: :tech_stack_search
end
