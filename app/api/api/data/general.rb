require 'doorkeeper/grape/helpers'
require 'json'

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

            get '/:id/data_fields' do
              DataField.where(project_id: params[:id])
            end
            params do
              requires :url, type: String
              requires :data, type: Array
            end
            put '/:id/scripts/:id_script' do
              error!('401 Unauthorized', 401) unless Script.find_by(id: params[:id_script]).project_id == params[:id].to_i and Project.find_by(id: params[:id]).user_id == doorkeeper_token[:resource_owner_id]
              script = Script.find_by(id: params[:id_script])
              script.xpaths = {"url" => params[:url], "data" => params[:data]} #request.body.read
              script.save!
            end

            get '/:id/scripts/:id_script' do
              error!('401 Unauthorized', 401) unless Script.find_by(id: params[:id_script]).project_id == params[:id].to_i and Project.find_by(id: params[:id]).user_id == doorkeeper_token[:resource_owner_id]
              xpaths = Script.find_by(id: params[:id_script]).xpaths
              if xpaths == {}
                xpaths = {"url" => "" , "data" => []}
                DataField.where(project_id: params[:id]).each do |d| xpaths["data"].append("name" => d.name, "value" => "") end
                xpaths
              else
                names = DataField.where(project_id: params[:id]).pluck("name")
                del_indx = []
                xpaths["data"].each do |xpath|
                  if names.include?(xpath["name"])
                    names.delete_at(names.index(xpath["name"]))
                  else
                    del_indx.append(xpaths["data"].index(xpath))
                  end
                end
                del_indx.each do |indx| xpaths["data"].delete_at(indx) end
                names.each do |name| xpaths["data"].append("name" => name, "value" => "") end
                xpaths
              end
            end
          end
        end
      end

      resource :login_check do
        get '' do
          {}
        end
      end
    end
  end
end
