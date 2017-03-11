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
    script.log_level = 1
    script.save
    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    expect(extraction.instances.first.extraction_data[0].value).to eq "Gems"
    expect(extraction.instances.first.extraction_data[1].value).to eq "Find, install, and publish RubyGems."
    script = Script.find(script.id)
    expect(script.last_run).to be > script.created_at
  end

  it 'should extract gem name and its version + nested hash value' do
    script = create(:script)
    json = {}
    json['url'] = "https://rubygems.org/gems"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "gem_name"
    json['data'][0]['xpath'] = "/html/body/main/div/a[1]/span/h2"
    json['data'][1] = {}
    json['data'][1]['name'] = "version"
    json['data'][1]['value'] = "/html/body/main/div/a[1]/span/h2/span/text()"
    json['data'][1]['postprocessing'] = []
    json['data'][1]['postprocessing'][0] = {}
    json['data'][1]['postprocessing'][0]['type'] = "nested"
    json['data'][1]['postprocessing'][0]['data'] = []
    json['data'][1]['postprocessing'][0]['data'][0] = {}
    json['data'][1]['postprocessing'][0]['data'][0]['name'] = "hash"
    json['data'][1]['postprocessing'][0]['data'][0]['xpath'] = "/html/body/main/div/div/div[1]/div[3]/div[2]/text()"
    script.xpaths = json.to_json
    script.log_level = 1
    script.save
    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    #expect(extraction.instances.first.extraction_data[0].value).to eq "a"
    expect(extraction.instances.first.extraction_data[1].value).to eq "0.1.1"
    #expect(extraction.instances.first.extraction_data[2].value).to eq "233dca77fe5df2ef831943993ae7448963f89027929468622c30767a4e8f2357"
    script = Script.find(script.id)
    expect(script.last_run).to be > script.created_at
  end
end