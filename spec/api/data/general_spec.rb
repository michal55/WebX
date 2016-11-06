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
end
