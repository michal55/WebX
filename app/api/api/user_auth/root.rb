module API
  module User_auth
    class Root < Grape::API
      mount API::User_auth::User_auth
    end
  end
end
