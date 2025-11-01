Rails.application.routes.draw do
  # Use custom JSON-only controllers and restrict session routes to POST/DELETE only
  devise_for :users, skip: [:sessions], controllers: {
    registrations: "users/registrations"
  }
  devise_scope :user do
    post   "users/sign_in",  to: "users/sessions#create"
    delete "users/sign_out", to: "users/sessions#destroy"
  end
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
