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
      expect(frequency.last_run).to eq(DateTime.parse("2017-01-01 13:00:00 UTC"))

      # Should not run here
      t = Time.parse("2017-01-01 13:08:00 UTC")
      Timecop.travel(t)

      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("2017-01-01 13:00:00 UTC"))

      # Here should run second time
      t = Time.parse("2017-02-02 17:28:00 UTC")
      Timecop.travel(t)

      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("2017-02-02 17:25:00 UTC"))

      # Only 2 extraction should run
      e = Extraction.all
      expect(e.size).to eq(2)
    end
  end

  it 'should crawl running frequency' do

    frequency = create(:frequency_run_in_past)
    frequency_id = frequency.id
    t = Time.parse("2017-02-21 14:58:00 UTC")
    Timecop.travel(t)
    with_resque do
      # Enqueue
      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      # Should not run here
      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("2017-02-21 15:00:00 UTC"))

      # Should not run here
      t = Time.parse("2017-02-21 17:45:00 UTC")
      Timecop.travel(t)

      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("2017-02-21 15:00:00 UTC"))

      # Here should run first time
      t = Time.parse("2017-02-21 18:06:00 UTC")
      Timecop.travel(t)

      Resque.enqueue(CrawlerInitializer)
      sleep(5)

      frequency = Frequency.find(frequency_id)
      expect(frequency.last_run).to eq(DateTime.parse("2017-02-21 18:05:00 UTC"))

      # Only 1 extraction should run
      e = Extraction.all
      expect(e.size).to eq(1)
    end
  end
end
