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
            script_id = Integer params[:script_id]

            if params[:limit]
              limit = Integer params[:limit]
              limit = 100 if limit < 100
            else
              limit = 10
            end

            if params[:offset]
              offset = Integer params[:offset]
            else
              offset = 10
            end
          rescue
            error!(make_error_json('Parameters not valid.'),404)
          end
          puts(token,script_id,limit,offset)
          { hello: "ok" }
        end
      end

      helpers do
        def make_error_json(text)
          error_msg =  "#{text} Read manual at #{request.base_url}#{Rails.application.config.relative_url_root}#{Rails.application.routes.url_helpers.api_export_instructions_path }"
          { error: "#{error_msg}" }
        end
      end

    end
  end
end

