require 'rspec'
require 'rails_helper'
require 'json'

describe 'Exporting API' do
  # listing
  it 'Listing should have token and script_id required' do
    script = create(:script)
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # No param
    get '/api/export/list'
    expect(response.response_code).to eq(404)
    # Token only
    get "/api/export/list?token=#{user.api_key}"
    expect(response.response_code).to eq(404)
    # script_id only
    get "/api/export/list?script_id=#{script.id}"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}"
    expect(response.response_code).to eq(200)
  end

  it 'Listing numbers should be correct' do
    script = create(:script)
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # Incorrect script_id
    get "/api/export/list?token=#{user.api_key}&script_id=xy#{script.id}&offset=0&limit=10"
    expect(response.response_code).to eq(404)
    # Incorrect offset
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}&offset=xy0&limit=10"
    expect(response.response_code).to eq(404)
    # Incorrect limit
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}&offset=0&limit=xy10"
    expect(response.response_code).to eq(404)
    # Incorrect since
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}&since=2200-01-01"
    expect(response.response_code).to eq(404)
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}&since=xyz"
    expect(response.response_code).to eq(404)
    # Incorrext last extracton id
    get "/api/export/extraction?token=#{user.api_key}&id=#{script.id}&last_extraction_id=xyz"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}&offset=0&limit=10&since=1990-01-01&last_extraction_id=5000"
    expect(response.response_code).to eq(200)

  end

  it 'Listing token and script id must match' do
    script = create(:script)
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # Invalid token
    get "/api/export/list?token=xyz&script_id=#{script.id}"
    expect(response.response_code).to eq(404)
    # Invalid script id
    get "/api/export/list?token=#{user.api_key}&script_id=5"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}"
    expect(response.response_code).to eq(200)
  end

  it "Listing should return correct values" do
    extraction = create(:extraction)
    script = extraction.script
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}"
    expect(response.response_code).to eq(200)
    json = JSON.parse(response.body)
    expect(json['data'][0]['id']).to eq(extraction.id)
    expect(json['data'][0]['created_at'][0..9]).to eq(extraction.created_at.to_s[0..9])
    expect(json['data'][0]['success']).to eq(extraction.success)

  end

  # extracting
  it 'Extraction should have token and extraction_id required' do
    extraction = create(:extraction)
    script = extraction.script
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true


    # No param
    get '/api/export/extraction'
    expect(response.response_code).to eq(404)
    # Token only
    get "/api/export/extraction?token=#{user.api_key}"
    expect(response.response_code).to eq(404)
    # script_id only
    get "/api/export/extraction?id=#{extraction.id}"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}"
    expect(response.response_code).to eq(200)
  end

  it 'Extraction numbers should be correct' do
    extraction = create(:extraction)
    script = extraction.script
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # Incorrect script_id
    get "/api/export/extraction?token=#{user.api_key}&id=xy#{extraction.id}&offset=0&limit=10"
    expect(response.response_code).to eq(404)
    # Incorrect offset
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}&offset=xy0&limit=10"
    expect(response.response_code).to eq(404)
    # Incorrect limit
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}&offset=0&limit=xy10"
    expect(response.response_code).to eq(404)
    # Incorrect since
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}&since=2200-01-01"
    expect(response.response_code).to eq(404)
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}&since=xyz"
    expect(response.response_code).to eq(404)
    # Incorrect last instance
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}&last_instance_id=xyz"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}&&last_instance_id=1"
    expect(response.response_code).to eq(200)
  end

  it 'Extraction token and extraction id must match' do
    extraction = create(:extraction)
    script = extraction.script
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # Invalid token
    get "/api/export/extraction?token=xyz&id=#{extraction.id}"
    expect(response.response_code).to eq(404)
    # Invalid script id
    get "/api/export/extraction?token=#{user.api_key}&id=5"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/extraction?token=#{user.api_key}&id=#{extraction.id}"
    expect(response.response_code).to eq(200)
  end
end
