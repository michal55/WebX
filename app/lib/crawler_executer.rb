class CrawlerExecuter

  # Retry the failed job
  extend Resque::Plugins::Retry
  extend Resque::Plugins::ExponentialBackoff

  @queue = :crawler_executer

  # Failed job restore times
  @backoff_strategy = [60, 5*60, 30*60, 2*60*60]

  # Action
  def self.perform(script_id)
    print('[DEBUG] Crawler Executer: ', script_id, "\n")
    script = Script.find(script_id)
    Crawler.execute(script)
  end

end
