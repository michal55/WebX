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
    frequencies_new,frequencies = find_frequencies(time_now)
    puts(frequencies_new.length, frequencies.length)

    frequencies_new.each do |f|
      # First run frequencies
      f.last_run = time_now
      f.save!
      script = f.script
      Crawler.execute(script)
    end

    frequencies.each do |f|
      # Regular run
      f.last_run = time_now
      f.save!
      script = f.script
      Crawler.execute(script)
    end

  end

  def self.find_frequencies(time)

    freqencies_new = Frequency.where("first_exec < '#{time}' AND last_run IS NULL")
    freqencies = Frequency.where("EXTRACT(EPOCH FROM last_run) + epoch < '#{time.to_i}'")
    return freqencies_new,freqencies
  end


end
