require 'factory_girl_rails'
FactoryGirl.define do
  factory :script do
    name 'Script_Factory'
    after(:create) do |script|
      script.project = FactoryGirl.create(:project)
      script.xpaths = {}.to_json
      script.log_level = 1
      script.save!
    end
  end

  factory :script_api, class: Script do
    name 'Script_Factory_api'
    after(:create) do |script|
      script.project = FactoryGirl.create(:project_api)
      script.xpaths = {}.to_json
      script.log_level = 1
      script.save!
    end
  end

  factory :script_with_xpaths, class: Script do
    name 'Script_Factory'
    json = {}
    json['url'] = "https://rubygems.org/"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "navbar"
    json['data'][0]['xpath'] = "/html/body/header/div/div/nav/a[1]"
    json['data'][0]['postprocessing'] = nil
    json['data'][1] = {}
    json['data'][1]['name'] = "title"
    json['data'][1]['xpath'] = "/html/body/main/h1"
    json['data'][1]['postprocessing'] = nil

    after(:create) do |script|
      script.project = FactoryGirl.create(:project)
      script.xpaths = json.to_json
      script.log_level = 1
      script.save!
    end
  end

  factory :script_with_nested_and_restrict, class: Script do
    name 'Script_Factory'
    json = {}
    json['url'] = "https://www.alza.sk/pocitace/18852653.htm"
    json['data'] = []
    json['data'][0] = {}
    json['data'][0]['name'] = "category_url"
    json['data'][0]['xpath'] = "//*[@id=\"litp18852653\"]/div[2]/ul/li[position() < 4]/span/a"
    json['data'][0]['postprocessing'] = []
    json['data'][0]['postprocessing'][0] = {}
    json['data'][0]['postprocessing'][0]['type'] = "nested"
    json['data'][0]['postprocessing'][0]['data'] = []
    json['data'][0]['postprocessing'][0]['data'][0] = {}
    json['data'][0]['postprocessing'][0]['data'][0]['name'] = "category"
    json['data'][0]['postprocessing'][0]['data'][0]['xpath'] = "//*[@id=\"rootHtml\"]/head/title"
    json['data'][0]['postprocessing'][0]['data'][1] = {}
    json['data'][0]['postprocessing'][0]['data'][1]['name'] = "product"
    json['data'][0]['postprocessing'][0]['data'][1]['xpath'] = "//*[@id=\"boxes\"]/div[position() < 4]"
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'] = []
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0] = {}
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['type'] = "restrict"
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'] = []
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'][0] = {}
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'][0]['name'] = "title"
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'][0]['xpath'] = "//div[1]/div/a"
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'][1] = {}
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'][1]['name'] = "price"
    json['data'][0]['postprocessing'][0]['data'][1]['postprocessing'][0]['data'][1]['xpath'] = "//div[2]/div[2]/div/span[1]"

    after(:create) do |script|
      script.project = FactoryGirl.create(:project)
      script.xpaths = json.to_json
      script.log_level = 0
      script.save!
    end
  end
end
