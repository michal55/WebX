module API
  module Export
    class Export < Grape::API
      format :json
      resource 'export' do
        get :hello do
          { hello: 'world' }
        end
      end
    end
  end
end
