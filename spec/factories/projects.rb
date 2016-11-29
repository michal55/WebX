FactoryGirl.define do
  factory :project do
    name 'Project_Factory'
    after(:create) do |project|
      project.user = FactoryGirl.create(:user)
      project.save!
    end
  end
  factory :project_api, class: Project do
    name 'Project_Factory_api'
    after(:create) do |project|
      project.user = FactoryGirl.create(:user_api)
      project.save!
    end
  end

end
