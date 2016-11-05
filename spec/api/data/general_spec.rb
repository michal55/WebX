require 'rails_helper'

describe 'user_auth API', type: :request do
  include_context :doorkeeper_app_with_token

  it 'fails without access token' do
    get '/api/v0/data/user', format: :json
    expect(response.response_code).to eq(401)
  end

  it 'returns token owner data' do
    get '/api/v0/data/user', format: :json, access_token: access_token.token
    expect(response.body).to eq(user.to_json)
  end
end
