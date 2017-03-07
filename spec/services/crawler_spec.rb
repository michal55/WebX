require 'rspec'
require 'rails_helper'

describe 'Extracting data from rubygems.org' do

  it 'should extract first header' do
    script = create(:script)
    json = {}
    json['url'] = "https://rubygems.org/"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "navbar"
    json['data'][0]['value'] = "/html/body/header/div/div/nav/a[1]/text()"
    json['data'][1] = {}
    json['data'][1]['name'] = "title"
    json['data'][1]['value'] = "/html/body/main/h1/text()"
    script.xpaths = json.to_json
    script.mode = 1
    script.save
    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    expect(extraction.extraction_data[0].value).to eq "Gems"
    expect(extraction.extraction_data[1].value).to eq "Find, install, and publish RubyGems."
    script = Script.find(script.id)
    expect(script.last_run).to be > script.created_at
  end

  it 'should extract field names in footer' do
    script = create(:script)
    json = {}
    json['url'] = "https://rubygems.org/"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "navbar"
    json['data'][0]['value'] = "/html/body/header/div/div/nav/a[1]/text()"
    json['data'][0]['post_processing'] = {}
    json['data'][0]['post_processing']['type'] = "nested"
    json['data'][0]['post_processing']['data'] = []
    json['data'][0]['post_processing']['data'][0]['name'] = "footer"
    json['data'][0]['post_processing']['data'][0]['value'] = "/html/body/footer/div[3]/div[1]/a/text()"
    script.xpaths = json.to_json
    script.mode = 1
    script.save
    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    expect(extraction.extraction_data[0].value).to eq "Gems"
    # add check if "English" has been crowled
    script = Script.find(script.id)
    expect(script.last_run).to be > script.created_at
  end
end