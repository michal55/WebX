class SampleResqueJob

  # Zabezpecime opakovanie jobu, ak zlyhal.
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff

  @queue = :sample_resque_job

  # Failnuty job sa obnovi o 1 minutu, potom znovu o 5 minut a napokon o 30 minut.
  @backoff_strategy = [60, 5*60, 30*60, 2*60*60]

  # Akcia pre Resque.
  def self.perform()
    puts 'Resque Sample'

  end


end
