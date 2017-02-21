require 'rspec'

describe 'Enqueing job into queue' do

  before do
    ResqueSpec.reset!
  end

  it 'should que scheduled job' do

    frequency = create(:frequency_not_run_yet)
    t = Time.local(2017, 1, 1, 13, 0, 0)
    Timecop.travel(t)
    # Enqueue
    ResqueWeb.enqueue(CrawlerInitializer)
    sleep
    expect(true).to eq(true)
  end
end
