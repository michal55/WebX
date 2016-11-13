require 'rails_helper'

RSpec.describe DataSchema, type: :model do
  it "FactoryGirl should create data schema with associations" do
    x = create(:data_schema)
    expect(x.project.user.email).to eq('test@example.com')
  end
end
