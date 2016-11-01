require 'rails_helper'

RSpec.describe Project, type: :model do
  it "Factory girl should create project with user association" do
    x  = FactoryGirl.create(:project)
    expect(x.user.email).to eq('test@example.com')
  end
end
