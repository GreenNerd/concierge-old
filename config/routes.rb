Rails.application.routes.draw do
  resource :settings, only: [:show]
end
