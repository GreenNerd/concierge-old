Rails.application.routes.draw do
  resource :settings, only: [:show, :update]
  resources :availabilities, only: [:index]
end
