FactoryGirl.define do
  factory :extraction do
    success true
    execution_time 4.5
    after(:create) do |extraction|
      extraction.script = FactoryGirl.create(:script)
      extraction.save!
    end
  end
end
