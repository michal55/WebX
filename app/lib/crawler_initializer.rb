class CrawlerInitializer

  # Retry the failed job
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff

  @queue = :crawler_initializer

  # Failed job restore times
  @backoff_strategy = [60, 5*60, 30*60, 2*60*60]

  # Action
  def self.perform()
    # Get scripts where first exec is in history and last exec is null || last exec + period * frequency < now
    # run crawler in loop
    # update last run
    # for skrit.na_vykonanmie?.first do |s|
    #     s.lastrun =  now
    #     new tread(crawler.execute(s)) #10minut
    # end

  end

  def self.find_scripts
    t = Time.now
    freqencies = Frequency.where("first_exec < '#{Time.now}' AND last_run IS NULL")
    freqencies << Frequency.where("'date' last_run + interval period  > '#{Time.now}'")
  end


end
