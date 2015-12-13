Rails.application.config.assets.precompile += %w( analytics.js )

if Rack::Utils.respond_to?("key_space_limit=")
  Rack::Utils.key_space_limit = 68719476736
end