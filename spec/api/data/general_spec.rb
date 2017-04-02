require 'rails_helper'

describe 'API data/', type: :request do
  include_context :doorkeeper_app_with_token

  context 'user' do
    it 'fails without access token' do
      get '/api/data/user', format: :json
      expect(response.response_code).to eq(401)
    end

    it 'with token returns data about token owner' do
      get '/api/data/user', format: :json, access_token: access_token.token
      expect(response.body).to eq(user.to_json)
    end
  end

  context 'json_script' do
    it 'put API saves json into script.xpaths and get API returns the saved value' do
      script = create(:script_api)
      project_id = script.project_id
      script_id = script.id
      script_data = '{"url":"www.google.com","data":[{"name":"Integer","value":"12345"},{"name":"String","value":"tralala"}]}'
      access_token = create(:doorkeeper_token, resource_owner_id: Project.find_by(id: project_id).user_id)

      put "/api/data/user/project/#{project_id}/scripts/#{script_id}", format: :json, access_token: access_token.token ,'ACCEPT' => 'application/json',
          'CONTENT_TYPE' => 'application/json', 'url' => 'www.google.com', 'data' => [{'name' => 'Integer', 'value' => '12345'}, {'name' => 'String', 'value'=>'tralala'}]
      expect(response.response_code).to eq(200)
      script.reload
      expect(script.xpaths.to_json).to eq(script_data)

      get "/api/data/user/project/#{project_id}/scripts/#{script_id}", format: :json, access_token: access_token.token
      expect(response.body).to eq(script_data)
    end
  end
end
