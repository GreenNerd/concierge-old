Rails.application.routes.draw do
  get 'appointments/query' => 'appointments#query', as: :query_appointment
  resources :appointments, only: [:new, :create, :show, :index]

  namespace :admin do
    resource :settings, only: [:show, :update]
    resources :availabilities, only: [:index, :create, :destroy]
    resources :business_categories, only: [:index, :create, :show, :destroy]

    get 'appointments', to: 'appointments#index'
    root 'appointments#admin'
  end

  root 'appointments#index'
end
