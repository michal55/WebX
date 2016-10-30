require 'rails_helper'

describe Api::EchoController, type: :controller do
  describe 'GET #index' do
    it 'returns 401 without authentication token' do
      get :index
      expect(response).to have_http_status(401)
    end
  end

  describe 'GET #index (when doorkeeper_token is stubbed)' do
    let(:token) { double :acceptable? => true }

    before do
      allow(@controller).to receive(:doorkeeper_token) { token }
    end

    it 'echoes back message' do
      params = { message: 'Hello world!' }
      get :index, params
      expect(response).to have_http_status(200)
      expect(response.body).to eq params.to_json
    end
  end
end
