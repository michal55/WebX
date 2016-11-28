FactoryGirl.define do
  factory :user, class: User do
    email 'test@example.com'
    password 'password'
    name 'name'
    surname 'surname'
    role :user
  end

  factory :other_user, class: User do
    email 'test1@example.com'
    password 'password'
    name 'name1'
    surname 'surname1'
  end
  factory :user_api, class: User do
    email 'test1@example.com'
    password 'password'
    name 'name1'
    surname 'surname1'
    role :user
  end

end
