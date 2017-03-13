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
    json['data'][0]['xpath'] = "/html/body/header/div/div/nav/a[1]/text()"
    json['data'][1] = {}
    json['data'][1]['name'] = "title"
    json['data'][1]['xpath'] = "/html/body/main/h1/text()"
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

  it 'should extract name of the master branch from website GitHub' do
    script = create(:script)
    json = {}
    json['url'] = "https://github.com/michal55/WebX-Team16"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "title"
    json['data'][0]['xpath'] = '//*[@id="js-repo-pjax-container"]/div[2]/div[1]/div[1]/div[1]/div/span'
    json['data'][1] = {}
    json['data'][1]['name'] = "branches_url"
    json['data'][1]['xpath'] = '//*[@id="js-repo-pjax-container"]/div[2]/div[1]/div[2]/div/div/ul/li[2]/a'
    json['data'][1]['postprocessing'] = []
    json['data'][1]['postprocessing'][0] = {}
    json['data'][1]['postprocessing'][0]['type'] = "nested"
    json['data'][1]['postprocessing'][0]['data'] = []
    json['data'][1]['postprocessing'][0]['data'][0] = {}
    json['data'][1]['postprocessing'][0]['data'][0]['name'] = "name_of_branch"
    json['data'][1]['postprocessing'][0]['data'][0]['xpath'] = '//*[@id="branch-autoload-container"]/div/div[2]/div/span[1]/a'
    script.xpaths = json.to_json
    script.log_level = 0
    script.save
    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    datum = ExtractionDatum.find_by(field_name: "title")
    expect(datum.value).to eq "\n            Web page of team 16\n          "
    datum = ExtractionDatum.find_by(field_name: "branches_url")
    expect(datum.value).to eq "/michal55/WebX-Team16/branches"
    datum = ExtractionDatum.find_by(field_name: "name_of_branch")
    expect(datum.value).to eq "master"
    script = Script.find(script.id)
    expect(script.last_run).to be > script.created_at
  end
end