FactoryGirl.define do
  factory :frequency, class: Frequency do
    interval 23
    period 'day'
    after(:create) do |frequency|
      frequency.script = FactoryGirl.create(:script)
      frequency.save!
    end
  end

  factory :frequency_not_run_yet, class: Frequency do
    interval 10
    period 'minute'
    last_run nil
    first_exec DateTime.parse("1.1.2017 13:00")
    after(:create) do |frequency|
      frequency.script = FactoryGirl.create(:script_with_xpaths)
      frequency.save!
    end
  end

  factory :frequency_run_in_past, class: Frequency do
    interval 3
    period 'hour'
    last_run DateTime.parse("21.2.2017 15:00")
    first_exec DateTime.parse("1.1.2017 13:00")
    after(:create) do |frequency|
      frequency.script = FactoryGirl.create(:script_with_xpaths)
      frequency.save!
    end
  end
end
