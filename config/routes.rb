Rails.application.routes.draw do
  resources :appointments, only: [:new, :create, :show, :index] do
    collection do
      get :query
      get :closed
    end
  end

  namespace :admin do
    resource :settings, only: [:show, :update]
    resources :availabilities, only: [:index, :create, :destroy]
  end

  root 'appointments#index'
end
