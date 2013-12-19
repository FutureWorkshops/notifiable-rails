require 'simplecov'
SimpleCov.start do
  minimum_coverage 70
  add_filter "/spec/"
  add_filter "/config/"
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../test_app/config/environment.rb",  __FILE__)
require File.expand_path("../../lib/fwt_push_notification_server.rb",  __FILE__)
require 'rspec/rails'
require 'rspec/autorun'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

FwtPushNotificationServer.delivery_method = :test

RSpec.configure do |config|  
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  
  config.before(:each) {
    FwtPushNotificationServer.deliveries.clear
  }
end
