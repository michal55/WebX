require 'rspec'

describe 'Create' do

  it 'should create valid user' do
    user = FactoryGirl.build(:user)
    expect(user.save!).to eq true
  end

  it 'should not create 2 users' do
    user = FactoryGirl.build(:user)
    expect(user.save!).to eq true
    user2 = FactoryGirl.build(:user)
    expect{ user2.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not create user without email' do
    user = FactoryGirl.build(:user)
    user.email = nil
    expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'should not create user without password' do
    user = FactoryGirl.build(:user)
    user.password = nil
    expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
end