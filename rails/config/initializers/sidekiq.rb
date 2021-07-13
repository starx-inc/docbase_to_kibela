Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch("REDIS_URL"), namespace: 'doc2kibe' }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch("REDIS_URL"), namespace: 'doc2kibe' }
end
