FactoryGirl.define do
  factory :data_field do
    name 'name_integer'
    data_type DataField.data_types[:integer]
    after(:create) do |data_field|
      data_field.project = FactoryGirl.create(:project)
      data_field.save!
    end
  end
  factory :data_field_general, class: DataField do
    name 'name'
    data_type DataField.data_types[:integer]
    project_id 10000
  end

end
