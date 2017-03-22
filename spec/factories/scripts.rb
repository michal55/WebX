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
end
