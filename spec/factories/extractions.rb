FactoryGirl.define do
  factory :extraction do
    success true
    execution_time 4.5
    after(:create) do |extraction|
      extraction.script = FactoryGirl.create(:script)

      instance = Instance.new
      extraction_data = ExtractionDatum.new

      instance.id = 2
      instance.extraction = extraction
      instance.is_leaf = true
      instance.parent_id = instance.id
      extraction_data.instance = instance
      extraction_data.field_name = "Sample Field"
      extraction_data.value = "value"
      extraction_data.save!
      instance.save!

      extraction.save!
    end
  end
end
