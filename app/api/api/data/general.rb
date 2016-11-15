require 'doorkeeper/grape/helpers'

module API
  module Data
    class General < Grape::API
      helpers Doorkeeper::Grape::Helpers
      format :json
      
      before do
        doorkeeper_authorize!
      end

      resource :data do
        get :user do
          User.find(doorkeeper_token[:resource_owner_id])
        end

        resource :user do
          get :projects do
            Project.where(user_id: doorkeeper_token[:resource_owner_id])
          end

          resource :project do
            get '/:id/scripts' do
              error!('401 Unauthorized', 401) unless Project.find_by(id: params[:id]).user_id == doorkeeper_token[:resource_owner_id]
              Script.where(project_id: params[:id])
            end
          end
        end

        get :projects do
          Project.all
        end
      end
    end
  end
end
