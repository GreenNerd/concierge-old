Rails.application.routes.draw do
  resources :appointments, param: :id_number, only: [:new, :create, :show]

  resource :settings, only: [:show, :update]
  resources :availabilities, only: [:index, :create, :destroy]

  root 'appointments#new'
end
