module API
  module Export
    class Export < Grape::API
      include ExtractionDatumMapper
      require 'set'
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
            limit = limit_init(params[:limit])
            offset = offset_init(params[:offset])
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

          authorize_user(user,token)

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

        get :extraction do

          if not params[:token] or not params[:extraction_id]
            # Params not present
            error!(make_error_json('Token or extraction_id is missing.'),404)
          end

          begin
            # Params are valid
            token = params[:token]
            extraction_id = (Integer params[:extraction_id]).abs
            limit = limit_init(params[:limit])
            offset = offset_init(params[:offset])
          rescue
            error!(make_error_json('Parameters not valid.'),404)
          end

          begin
            extraction = Extraction.find(extraction_id)
            script = Script.find(extraction.script_id)
            project = Project.find(script.project_id)
            user = User.find(project.user_id)
          rescue
            error!(make_error_json('Script, Project or User with this ID does not exist.'),404)
          end

          authorize_user(user, token)

          leafs = Instance.where(extraction_id: extraction_id).where(is_leaf: true).order('created_at ASC').offset(offset).limit(limit)
          if leafs.length == 0
            error!(make_error_json('Unavailable data.'),404)
          end

          fields_array = ExtractionDatumMapper.get_field_array(leafs)

          response_array = []
          leafs.each do |leaf|
            leaf_dict = {}
            leaf_dict['id'] = leaf.id
            row = ExtractionDatumMapper.make_row(leaf,fields_array)
            (0..(row.length-1)).each do |i|
              leaf_dict[fields_array[i]] = row[i]
            end
            response_array << leaf_dict
          end

          info = {}
          info['extraction_id'] = extraction.id
          info['extraction_execution_time'] = extraction.execution_time
          info['script_id'] = script.id
          info['instances_count'] = leafs.length


          {
              info: info,
              data: response_array
          }
        end
      end

      helpers do
        def limit_init(param)
          if param
            limit = (Integer param).abs
            limit = 100 if limit > 100
          else
            limit = 10
          end
          limit
        end

        def offset_init(param)
          if param
            offset = (Integer param).abs
          else
            offset = 0
          end
          offset
        end

        def authorize_user(user, token)
          if user.api_key != token
            error!(make_error_json('Invalid token.'),404)
          end
        end

        def make_error_json(text)
          error_msg =  "#{text} Read manual at #{request.base_url}#{Rails.application.config.relative_url_root}#{Rails.application.routes.url_helpers.export_api_instructions_path  }"
          { error: "#{error_msg}" }
        end
      end

    end
  end
end

