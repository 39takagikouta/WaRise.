Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', nil) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', nil) }
end

require 'sidekiq/api'
require 'sidekiq'
require 'sidekiq-scheduler'
