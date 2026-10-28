class Rack::Attack
 
  # Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new
  Rack::Attack.cache.store = ActiveSupport::Cache::RedisCacheStore.new #(url: "redis://localhost:6379/0/cache") 

  ### Throttle ActiveAdmin Logins by IP ###
  # Limits an IP address to 5 login attempts every 1 minute.
  throttle('limit admin logins by ip', limit: 5, period: 1.minute) do |req|
    if req.path == '/admin/login' && req.post?
      req.ip
    end
  end

  ### Throttle ActiveAdmin Logins with Email ###
  # Limits login attempts for a email parameter to 5 requests every 5 minutes.
  throttle('limit admin logins by email', limit: 5, period: 5.minutes) do |req|
    if req.path == '/admin/login' && req.post?
      req.params.dig('admin_user', 'email').to_s.downcase.strip.presence
    end
  end

end
