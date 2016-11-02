module API
  module User_auth
    class User_auth < Grape::API
      version 'user_auth'
      format :json
 
      resource :user_auth do
        desc "Return list of recent posts"
        get do
          User.all
        end
      end
    end
  end
end
