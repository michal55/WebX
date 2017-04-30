module API
  module Export
    class Export < Grape::API
      include ExtractionDatumMapper
      require 'set'
      format :json

      resource :export do
        get :list do
          if not params[:token] or not params[:script_id]
            # Params not present
            error!(make_error_json('Token or script ID is missing.'),404)
          end

          begin
            # Params are valid
            token = params[:token]
            script_id = (Integer params[:script_id]).abs
            limit = limit_init(params[:limit])
            offset = offset_init(params[:offset])
            last_extraction_id = last_extraction_id_init(params[:last_extraction_id])
            since = since_init(params[:since])
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

          extractions = Extraction.where(script_id: script_id).where("created_at >= ?",since).where("id < ?", last_extraction_id).order('created_at DESC').offset(offset).limit(limit)
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

          if not params[:token] or not params[:id]
            # Params not present
            error!(make_error_json('Token or extraction ID is missing.'),404)
          end

          script_id = nil
          extraction_id = nil

          begin
            # Params are valid
            token = params[:token]
            if params[:id] == 'last'
              last = true
              if not params[:script_id]
                error!(make_error_json('Script id is missing'),404)
              else
                script_id = (Integer params[:script_id]).abs
              end
            else
              last = false
              extraction_id = (Integer params[:id]).abs
            end
            limit = limit_init(params[:limit])
            offset = offset_init(params[:offset])
            last_instance_id = last_instance_id_init(params[:last_instance_id])
            since = since_init(params[:since])
          rescue
            error!(make_error_json('Parameters not valid.'),404)
          end

          begin
            if last
              extraction = Extraction.where(script_id: script_id).order('created_at DESC').limit(1).first
              extraction_id = extraction.id
            else
              extraction = Extraction.find(extraction_id)
            end
            script = Script.find(extraction.script_id)
            project = Project.find(script.project_id)
            user = User.find(project.user_id)
          rescue
            error!(make_error_json('Script, Project or User with this ID does not exist.'),404)
          end

          authorize_user(user, token)

          leafs = Instance.where(extraction_id: extraction_id).where('"instances"."created_at" >= ?', since).where("id > ?", last_instance_id).where(is_leaf: true).order('created_at ASC').offset(offset).limit(limit)
          if leafs.length == 0
            error!(make_error_json('Unavailable data.'),404)
          end

          fields_array = ExtractionDatumMapper.get_field_array(leafs)

          response_array = []
          leafs.each do |leaf|
            leaf_dict = {}
            leaf_dict['id'] = leaf.id
            leaf_dict['created_at'] = leaf.created_at
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
          info['instances_count'] = Instance.where(extraction_id: extraction_id).where(is_leaf: true).count


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

        def last_instance_id_init(param)
          if param
            last_instance_id = (Integer param).abs
          else
            last_instance_id = 0
          end
          last_instance_id
        end

        def last_extraction_id_init(param)
          if param
            last_extraction_id = (Integer param).abs
          else
            if Extraction.all.size == 0
              last_extraction_id = 1
            else
              last_extraction_id = Extraction.last.id + 1
            end
          end
          last_extraction_id
        end

        def since_init(param)
          if param
            since = DateTime.iso8601(param.tr(' ','+'))
          else
            since = DateTime.iso8601('1970-01-01T00:00:00+00:00')
          end
          since
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

