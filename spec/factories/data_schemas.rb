FactoryGirl.define do
  factory :data_schema do
    name 'name_integer'
    data_type DataSchema.data_types[:integer]
    after(:create) do |data_schema|
      data_schema.project = FactoryGirl.create(:project)
      data_schema.save!
    end
  end
end
