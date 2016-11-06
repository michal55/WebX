FactoryGirl.define do
  factory :doorkeeper_token, class: Doorkeeper::AccessToken do
    application_id { FactoryGirl.create(:doorkeeper_application).id }
    resource_owner_id { FactoryGirl.create(:user).id }
    scopes :public
  end
end
