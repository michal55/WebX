require 'doorkeeper/grape/helpers'

module API
  module User_auth
    class User_auth < Grape::API
      helpers Doorkeeper::Grape::Helpers
      version 'user_auth'
      format :json

      before do
        doorkeeper_authorize!
      end

      resource :user_auth do
        desc "Return list of recent posts"
        get do
          User.find(doorkeeper_token[:resource_owner_id])
        end
      end
    end
  end
end
