require 'factory_girl_rails'
FactoryGirl.define do
  factory :script do
    name 'Script_Factory'
    after(:create) do |script|
      script.project = FactoryGirl.create(:project)
      script.save!
    end
  end
  factory :script_api, class: Script do
    name 'Script_Factory_api'
    after(:create) do |script|
      script.project = FactoryGirl.create(:project_api)
      script.save!
    end
  end
end
