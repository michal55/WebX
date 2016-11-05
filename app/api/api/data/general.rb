require 'doorkeeper/grape/helpers'

module API
  module Data
    class General < Grape::API
      helpers Doorkeeper::Grape::Helpers
      version 'v0'
      format :json

      before do
        doorkeeper_authorize!
      end

      resource :data do
        get :user do
          User.find(doorkeeper_token[:resource_owner_id])
        end
      end
    end
  end
end
