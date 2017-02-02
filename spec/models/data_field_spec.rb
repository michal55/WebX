require 'rails_helper'

RSpec.describe DataField, type: :model do
  it "FactoryGirl should create data schema with associations" do
    x = create(:data_field)
    expect(x.project.user.email).to eq('test@example.com')
  end
end
