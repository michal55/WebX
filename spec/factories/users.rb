FactoryGirl.define do
  factory :user, class: User do
    email 'test@example.com'
    password 'password'
    role :user
  end

  factory :admin, class: User do
    email 'admin@example.com'
    password 'password'
  end
end
