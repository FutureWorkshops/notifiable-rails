require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  minimum_coverage 80
  add_filter "/spec/"
  add_filter "/config/"
end

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../test_app/config/environment",  __FILE__)
require File.expand_path("../../lib/notifiable",  __FILE__)
require File.expand_path("../../app/controllers/notifiable/device_tokens_controller",  __FILE__)
require 'database_cleaner'
require 'rspec/rails'
require 'factory_girl_rails'

Rails.backtrace_cleaner.remove_silencers!

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

DatabaseCleaner.strategy = :truncation

ActiveRecord::Migrator.migrate(File.join(Rails.root, 'db/migrate'))

RSpec.configure do |config|  
  config.mock_with :rspec
  config.use_transactional_fixtures = true
  config.infer_base_class_for_anonymous_controllers = false
  config.order = "random"
  config.include EngineControllerTestMonkeyPatch, :type => :controller
  config.include Requests::JsonHelpers, :type => :controller
  
  # Remove need for factory girl prefix
  config.include FactoryGirl::Syntax::Methods
  
  # errors for deprecations
  config.raise_errors_for_deprecations!
  
  config.before(:each) {
    DatabaseCleaner.start
    Notifiable.delivery_method = :send
  }
  
  config.after(:each) {
    DatabaseCleaner.clean
  }
end

class MockNotifier < Notifiable::NotifierBase
  def enqueue(device_token)
    processed(device_token, 0)
  end
end

Notifiable.notifier_classes[:mock] = MockNotifier
