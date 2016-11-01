require 'factory_girl_rails'
FactoryGirl.define do
  factory :script do
    name 'Script_Factory'
    after(:create) do |script|
      script.project = FactoryGirl.create(:project)
    end
  end
end
