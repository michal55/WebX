FactoryGirl.define do
  factory :frequency do
    interval 23
    period 'day'
    after(:create) do |frequency|
      frequency.script = FactoryGirl.create(:script)
      frequency.save!
    end
  end
end
