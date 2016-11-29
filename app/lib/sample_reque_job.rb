class SampleResqueJob

  # Retry the failed job
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff

  @queue = :sample_resque_job

  # Failed job restore times
  @backoff_strategy = [60, 5*60, 30*60, 2*60*60]

  # Action
  def self.perform()
    puts 'Resque Sample'
    sleep(5)
  end


end
