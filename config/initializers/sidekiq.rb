Sidekiq.configure_server do |config|
  config.redis = ENV.fetch("REDIS_URL")
end

Sidekiq.configure_client do |config|
  config.redis = ENV.fetch("REDIS_URL")
end

require 'sidekiq/api'
