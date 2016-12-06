class CrawlerInitializer

  # Retry the failed job
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff

  @queue = :crawler_initializer

  # Failed job restore times
  @backoff_strategy = [60, 5*60, 30*60, 2*60*60]

  # Action
  def self.perform()
    puts('[DEBUG] CRAWLER ENQUE')

    time_now = Time.now
    frequencies = Frequency.all

    frequencies.each do |f|
      should_run = f.last_run + eval(f.interval.to_s + '.' + f.period)

      if should_run > time_now
        # should run in future, not now
        next
      end

      f.last_run = Time.at((time_now.to_f/ 300).floor * 300 ) # floor to 5 min 
      f.save!
      script = f.script
      print("[DEBUG] Enqueing script: ", script.name,' | Frequency: ', f.id, "\n")
      Resque.enqueue(CrawlerExecuter,script.id)
    end

  end

end
