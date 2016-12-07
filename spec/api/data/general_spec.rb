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
    it 'return empty json from script' do
      script = create(:script_api) 
      project_id = script.project_id
      script_id = script.id
      create(:data_field_general, name: "Integer", data_type: DataField.data_types[:integer], project_id: project_id)
      create(:data_field_general, name: "String", data_type: DataField.data_types[:string], project_id: project_id)
      access_token = create(:doorkeeper_token, resource_owner_id: Project.find_by(id: project_id).user_id)
      get "/api/data/user/project/#{project_id}/scripts/#{script_id}", format: :json, access_token: access_token.token    
      expect(response.body).to eq("{\"url\":\"\",\"data\":[{\"name\":\"Integer\",\"value\":\"\"},{\"name\":\"String\",\"value\":\"\"}]}")
    end
    it 'return json saved in script.xpaths because it is correct according to data schema' do
      script = create(:script_api) #Script.find_by(name: "Script_Factory_api")
      script_id = script.id
      project_id = script.project_id
      create(:data_field_general, name: "Integer", data_type: DataField.data_types[:integer], project_id: project_id)
      create(:data_field_general, name: "String", data_type: DataField.data_types[:string], project_id: project_id)
      access_token = create(:doorkeeper_token, resource_owner_id: Project.find_by(id: project_id).user_id)
      script.xpaths = JSON.parse("{\"url\":\"www.google.com\",\"data\":[{\"name\":\"Integer\",\"value\":\"12345\"},{\"name\":\"String\",\"value\":\"tralala\"}]}")
      script.save!
      get "/api/data/user/project/#{project_id}/scripts/#{script_id}", format: :json, access_token: access_token.token    
      expect(response.body).to eq("{\"url\":\"www.google.com\",\"data\":[{\"name\":\"Integer\",\"value\":\"12345\"},{\"name\":\"String\",\"value\":\"tralala\"}]}")
    end
    it 'return repaired json according to data schema' do
      script = create(:script_api) #Script.find_by(name: "Script_Factory_api")
      script_id = script.id
      project_id = script.project_id
      create(:data_field_general, name: "Integer", data_type: DataField.data_types[:integer], project_id: project_id)
      create(:data_field_general, name: "String", data_type: DataField.data_types[:string], project_id: project_id)
      access_token = create(:doorkeeper_token, resource_owner_id: Project.find_by(id: project_id).user_id)
      script.xpaths = JSON.parse("{\"url\":\"www.google.com\",\"data\":[{\"name\":\"Testujeme\",\"value\":\"SSSDSDASDA\"},{\"name\":\"String\",\"value\":\"tralala\"}]}")
      script.save!
      get "/api/data/user/project/#{project_id}/scripts/#{script_id}", format: :json, access_token: access_token.token    
      expect(response.body).to eq("{\"url\":\"www.google.com\",\"data\":[{\"name\":\"String\",\"value\":\"tralala\"},{\"name\":\"Integer\",\"value\":\"\"}]}")
    end
    it 'saves json into script.xpaths' do
      script = create(:script_api)
      project_id = script.project_id
      script_id = script.id
      access_token = create(:doorkeeper_token, resource_owner_id: Project.find_by(id: project_id).user_id)
      put "/api/data/user/project/#{project_id}/scripts/#{script_id}", format: :json, access_token: access_token.token ,'ACCEPT' => "application/json", 'CONTENT_TYPE' => 'application/json',"url"=>"www.google.com", "data"=>[{"name"=>"Integer", "value"=>"12345"}, {"name"=>"String", "value"=>"tralala"}]#, body => "{\"url\":\"\",\"data\":[{\"name\":\"Integer\",\"value\":\"\"},{\"name\":\"String\",\"value\":\"\"}]}"
      expect(response.response_code).to eq(200)
      script.reload
      expect(script.xpaths.to_json).to eq("{\"url\":\"www.google.com\",\"data\":[{\"name\":\"Integer\",\"value\":\"12345\"},{\"name\":\"String\",\"value\":\"tralala\"}]}")
    end

  end
end
