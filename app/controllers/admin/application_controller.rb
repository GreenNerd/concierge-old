module Admin
  class ApplicationController < ::ApplicationController
    http_basic_authenticate_with name: 'admin', password: 'secret'
  end
end
