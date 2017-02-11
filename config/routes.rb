Rails.application.routes.draw do
  get 'appointments/query' => 'appointments#query', as: :query_appointment
  resources :appointments, only: [:new, :create, :show, :index]

  resource :settings, only: [:show, :update]
  resources :availabilities, only: [:index, :create, :destroy]

  root 'appointments#index'
end
