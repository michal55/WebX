require 'rails_helper'

RSpec.describe Script, type: :model do
  it "FactoryGirl should create script with associations" do
    x = create(:script)
    expect(x.project.user.email).to eq('test@example.com')
  end


end
