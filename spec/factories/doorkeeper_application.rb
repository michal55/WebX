FactoryGirl.define do
  sequence :unique_name do |n|
    "doorkeeper_application#{n}"
  end

  factory :doorkeeper_application, class: Doorkeeper::Application do
    name { generate(:unique_name) }
    redirect_uri 'https://app.com'
  end
end
