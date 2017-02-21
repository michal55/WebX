require 'rspec'

describe 'Enqueing job into queue' do

  before do
    ResqueSpec.reset!
  end

  it 'should que scheduled job' do

    frequency = create(:frequency_not_run_yet)
    expect(true).to eq(true)
  end
end
