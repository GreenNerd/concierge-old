Rails.application.routes.draw do
  get 'delete_appointment/index'

  get 'appointments/query' => 'appointments#query', as: :query_appointment
  resources :appointments, param: :id_number, only: [:new, :create, :show, :index]

  resource :settings, only: [:show, :update]
  resources :availabilities, only: [:index, :create, :destroy]
  resources :business_categories, only: [:index, :create, :show, :destroy]

  root 'appointments#index'
end
