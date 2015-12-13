require File.expand_path('../boot', __FILE__)

#require 'rails/all'
require "sprockets/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ImcloudAnalyticsDemo
  class Application < Rails::Application
  end
end
