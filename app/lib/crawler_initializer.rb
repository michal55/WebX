class CrawlerInitializer

  # Retry the failed job
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff

  @queue = :crawler_initializer

  # Failed job restore times
  @backoff_strategy = [60, 5*60, 30*60, 2*60*60]

  # Action
  def self.perform()
    puts('CRAWLER ENQUE')

    time_now = Time.now
    frequencies = Frequency.active(time_now)
    puts frequencies.size
    frequencies.each do |f|
      f.last_run = time_now #TODO last_run + interval*period
      f.save!
      script = f.script
      Crawler.execute(script)
    end

  end

end
