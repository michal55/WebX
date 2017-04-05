module API
  module Export
    class Export < Grape::API
      format :json

      resource 'export' do
        get :list do
          if not params[:token] or not params[:script_id]
            # Params not present
            error!(make_error_json('Token or script_id is missing.'),404)
          end

          begin
            # Params are valid
            token = params[:token]
            script_id = (Integer params[:script_id]).abs

            if params[:limit]
              limit = (Integer params[:limit]).abs
              limit = 100 if limit > 100
            else
              limit = 10
            end

            if params[:offset]
              offset = (Integer params[:offset]).abs
            else
              offset = 0
            end
          rescue
            error!(make_error_json('Parameters not valid.'),404)
          end

          begin
            script = Script.find(script_id)
            project = Project.find(script.project_id)
            user = User.find(project.user_id)
          rescue
            error!(make_error_json('Script, Project or User with this ID does not exist.'),404)
          end

          if user.api_key != token
            error!(make_error_json('Invalid token.'),404)
          end

          extractions = Extraction.where(script_id: script_id).order('created_at DESC').offset(offset).limit(limit)
          extractions_array = []

          extractions.each do |ext|
            extraction_dict = {}
            extraction_dict['id'] = ext.id
            extraction_dict['created_at'] = ext.created_at
            extraction_dict['success'] = ext.success
            extractions_array << extraction_dict
          end
          { data: extractions_array }
        end
      end

      helpers do
        def make_error_json(text)
          error_msg =  "#{text} Read manual at #{request.base_url}#{Rails.application.config.relative_url_root}#{Rails.application.routes.url_helpers.export_api_instructions_path  }"
          { error: "#{error_msg}" }
        end
      end

    end
  end
end

