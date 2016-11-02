module API
  class Root < Grape::API
    prefix 'api'
    mount API::User_auth::Root
  end
end
