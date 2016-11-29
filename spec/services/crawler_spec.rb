require 'rspec'
require 'rails_helper'

describe 'Extracting data from Lipsum.com' do

  it 'should extract first header' do
    script = create(:script)
    json = {}
    json['url'] = "https://rubygems.org/"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "navbar"
    json['data'][0]['value'] = "/html/body/header/div/div/nav/a[1]"
    json['data'][1] = {}
    json['data'][1]['name'] = "title"
    json['data'][1]['value'] = "/html/body/main/h1"
    script.xpaths = json.to_json
    script.save
    Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.extraction_data[0].value).to eq "Gems"
    expect(extraction.extraction_data[1].value).to eq "Find, install, and publish RubyGems."
  end
end