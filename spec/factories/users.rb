FactoryGirl.define do
  factory :user, class: User do
    email 'test@example.com'
    password 'password'
    role :user
  end

  factory :other_user, class: User do
    email 'test1@example.com'
    password 'password'
  end
end
