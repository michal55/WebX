require 'rspec'

describe 'Enqueing job into queue' do

  before do
    ResqueSpec.reset!
  end

  it 'should run first frequency' do

    frequency = create(:frequency_not_run_yet)
    frequency_id = frequency.id
    t = Time.parse("2017-01-01 13:00:01 UTC")
    Timecop.travel(t)
    with_resque do
      # Enqueue
      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      # First run
      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("1.1.2017 13:00"))

      # Should not run here
      t = Time.parse("2017-01-01 13:03:00 UTC")
      Timecop.travel(t)

      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("1.1.2017 13:00"))

      # Here should run second time
      t = Time.parse("2017-02-02 17:28:00 UTC")
      Timecop.travel(t)

      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("2.2.2017 17:25"))
      # expect(true).to eq(true)

      # Only 2 extraction should run
      e = Extraction.all
      expect(e.size).to eq(2)
    end
  end
end
