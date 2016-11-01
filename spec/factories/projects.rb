FactoryGirl.define do
  factory :project do
    name 'Project_Factory'
    after(:create) do |project|
      project.user = FactoryGirl.create(:user)
    end
  end
end
