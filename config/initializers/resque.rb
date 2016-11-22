# Resque tasks
require 'resque'
require 'resque-scheduler'
require 'resque/scheduler/server'
require 'resque-retry'
require 'resque-retry/server'

require 'resque/failure/multiple'
require 'resque/failure/redis'
require 'resque/rollbar'

Resque::Failure::Multiple.classes = [ Resque::Failure::Redis, Resque::Failure::Rollbar ]
Resque::Failure.backend = Resque::Failure::Multiple

Resque.schedule = YAML.load_file('resque_schedule.yml')

# Pripojenie na redis.
REDIS_CONFIG = YAML.load(File.open(Rails.root.join("config/redis.yml"))).symbolize_keys
default_config = REDIS_CONFIG[:default].symbolize_keys
if REDIS_CONFIG[Rails.env.to_sym]
  config = default_config.merge(REDIS_CONFIG[Rails.env.to_sym].symbolize_keys)
  Resque.redis = Redis.new(config)
end

Resque.after_fork do |job|
  Resque.redis.client.reconnect
end