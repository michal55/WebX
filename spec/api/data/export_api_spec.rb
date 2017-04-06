require 'rspec'
require 'rails_helper'

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
    # Correct
    get "/api/export/list?token=#{user.api_key}&script_id=#{script.id}&offset=0&limit=10"
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
    get "/api/export/extraction?extraction_id=#{extraction.id}"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=#{extraction.id}"
    expect(response.response_code).to eq(200)
  end

  it 'Extraction numbers should be correct' do
    extraction = create(:extraction)
    script = extraction.script
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # Incorrect script_id
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=xy#{extraction.id}&offset=0&limit=10"
    expect(response.response_code).to eq(404)
    # Incorrect offset
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=#{extraction.id}&offset=xy0&limit=10"
    expect(response.response_code).to eq(404)
    # Incorrect limit
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=#{extraction.id}&offset=0&limit=xy10"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=#{extraction.id}&offset=0&limit=10"
    expect(response.response_code).to eq(200)
  end

  it 'Extraction token and extraction id must match' do
    extraction = create(:extraction)
    script = extraction.script
    user = script.project.user
    user.confirm
    expect(user.confirmed?).to eq true

    # Invalid token
    get "/api/export/extraction?token=xyz&extraction_id=#{extraction.id}"
    expect(response.response_code).to eq(404)
    # Invalid script id
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=5"
    expect(response.response_code).to eq(404)
    # Correct
    get "/api/export/extraction?token=#{user.api_key}&extraction_id=#{extraction.id}"
    expect(response.response_code).to eq(200)
  end
end
