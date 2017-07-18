require 'rspec'
require 'rails_helper'

describe 'Extracting data from various sites' do

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
    expect(extraction.instances.first.extraction_data[1].value).to eq "News"
    expect(extraction.instances.first.extraction_data[2].value).to eq "Find, install, and publish RubyGems."
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
    json['data'][0]['xpath'] = '//*[@itemprop=\'about\']'
    json['data'][1] = {}
    json['data'][1]['name'] = "branches_url"
    json['data'][1]['xpath'] = '//a[@href=\'/michal55/WebX-Team16/branches\']'
    json['data'][1]['postprocessing'] = []
    json['data'][1]['postprocessing'][0] = {}
    json['data'][1]['postprocessing'][0]['type'] = "nested"
    json['data'][1]['postprocessing'][0]['data'] = []
    json['data'][1]['postprocessing'][0]['data'][0] = {}
    json['data'][1]['postprocessing'][0]['data'][0]['name'] = "name_of_branch"
    json['data'][1]['postprocessing'][0]['data'][0]['xpath'] = '//a[contains(@class,\'branch-name\')]'
    script.xpaths = json.to_json
    script.log_level = 0
    script.save

    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    datum = ExtractionDatum.find_by(field_name: "title", extraction: extraction)
    expect(datum.value).to eq "Web page of team 16"
    datum = ExtractionDatum.find_by(field_name: "name_of_branch")
    expect(datum.value).to eq "master"
    script = Script.find(script.id)
    expect(script.last_run).to be > script.created_at
  end

  it 'should extract notebook from restricted select xPath' do
    script = create(:script_with_nested_and_restrict)

    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    datum = ExtractionDatum.find_by(field_name: "category_url", extraction_id: extraction.id)
    expect(datum.value).to eq "[\"/notebooky/18842920.htm\", \"/alza-pocitace/18845023.htm\", \"/pocitacove-zostavy/18842956.htm\"]"
    datum = ExtractionDatum.find_by(field_name: "category", extraction_id: extraction.id)
    expect(datum.value).to eq "Notebooky | Alza.sk"
    #nemozem dat testovat na konkretny title, nakolko sa stale meni a padali by testy
    # datum = ExtractionDatum.find_by(field_name: "title", extraction_id: extraction.id)
  end

  it 'should extract first item from 3 pages' do
    script = create(:script)
    script.xpaths =
        {"url"=>"http://www.byty.sk/3-izbove-byty",
         "data"=>[{
                      "name"=>"offer-link",
                      "xpath"=>"//*[@id='inzeraty']/div[1]",
                      "postprocessing"=>[{
                                             "type"=>"restrict",
                                             "data"=>[{
                                                          "name"=>"offer",
                                                          "xpath"=>"//div/div[2]/h2/a",
                                                          "postprocessing"=>[]}]}]}, {
                      "name"=>"next_page",
                      "xpath"=>"//*[@rel='next']/@href",
                      "postprocessing"=>[{
                                             "type"=>"pagination",
                                             "limit"=>2}
                      ]
                  }
         ]
        }.to_json
    Crawling::Crawler.execute(script)
    extraction = Extraction.where(script_id: script.id).order(updated_at: :desc)[0]
    expect(extraction.success).to eq true
    expect(Instance.where(extraction_id: extraction.id, is_leaf: true).size).to eq 3
  end

  it 'should extract and validate data field types' do
    script = create(:script_with_nested_and_restrict)
    fields = [2]
    fields[0] = DataField.create(name: "category_url", data_type: "link", project: script.project)
    fields[1] = DataField.create(name: "price", data_type: "float", project: script.project)

    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    datum = ExtractionDatum.where(field_name: "category_url", extraction_id: extraction.id).order('created_at ASC')[1]
    expect(datum.value.start_with?("https:")).to eq true
    datum = ExtractionDatum.find_by(field_name: "price", extraction_id: extraction.id)
    expect(datum.value.to_f).not_to eq 0
  end

  it 'should extract date to date field' do
    script = create(:script)
    fields = DataField.create(name: "date", data_type: "date", project: script.project)

    json = {}
    json['url'] = "https://rubygems.org/gems/a"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "date"
    json['data'][0]['xpath'] = "/html/body/main/div/div/div[1]/div[2]/div/ol/li[1]/small"
    script.xpaths = json.to_json
    script.log_level = 1
    script.save

    Crawling::Crawler.execute(script)
    extraction = Extraction.find_by(script_id: script.id)
    expect(extraction.success).to eq true
    datum = ExtractionDatum.find_by(field_name: "date", extraction_id: extraction.id)
    expect(datum.value).not_to eq ""
  end

  it 'should check number data type' do
    processor = Crawling::Postprocessing.new()
    expect(processor.type_float("abc$12,345,678.9asl").to_f).to eq 12345678.9
    expect(processor.type_float("abc$12.345.678,9asl").to_f).to eq 12345678.9
    expect(processor.type_float("abc$12.345.678,9asl").to_f).to eq 12345678.9
    expect(processor.type_float("abc$12 345 678,9asl").to_f).to eq 12345678.9
    expect(processor.type_integer("abc$12,345,678.9asl").to_i).to eq 12345678
    expect(processor.type_integer("abc$12.345.678,9asl").to_i).to eq 12345678
    expect(processor.type_integer("abc$12.345.678,9asl").to_i).to eq 12345678
    expect(processor.type_integer("abc$12 345 678,9asl").to_i).to eq 12345678
  end

end