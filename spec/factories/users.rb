FactoryGirl.define do
  factory :user, class: User do
    email 'test@example.com'
    password 'password'
    role :user

    factory :admin, class: User do
      # Doesn't work
      #role :admin
    end
  end
end
