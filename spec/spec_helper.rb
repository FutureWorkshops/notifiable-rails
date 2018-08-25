# frozen_string_literal: true

require 'simplecov'
require 'simplecov-rcov'
SimpleCov.formatter = SimpleCov::Formatter::RcovFormatter
SimpleCov.start do
  minimum_coverage 80
  add_filter '/spec/'
  add_filter '/config/'
end

require File.expand_path('../lib/notifiable', __dir__)
require 'database_cleaner'
require 'factory_bot'

# Setup ActiveRecord
require 'active_record'
db_config = { adapter: 'postgis', host: 'localhost', port: 5432, database: 'notifiable-core-test' }
ActiveRecord::Base.establish_connection(db_config)
# ActiveRecord::Base.connection.create_database(db_config[:database])
ActiveRecord::Migration.verbose = true
migrations_path = File.join(File.dirname(__FILE__), '..', 'db', 'migrate')
ActiveRecord::MigrationContext.new(migrations_path).migrate

# Load support dir
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.mock_with :rspec
  config.order = 'random'

  # Remove need for factory girl prefix
  config.include FactoryBot::Syntax::Methods

  # errors for deprecations
  config.raise_errors_for_deprecations!

  config.before(:suite) do
    Notifiable.notifier_classes[:mock] = MockNotifier
    Notifiable.notifier_classes[:configurable_mock] = ConfigurableMockNotifier
    Notifiable::App.define_configuration_accessors(Notifiable.notifier_classes)
    DatabaseCleaner.strategy = :deletion, { except: %w[spatial_ref_sys] }
    DatabaseCleaner.clean_with :truncation, except: %w[spatial_ref_sys]
    # FactoryGirl.lint
  end

  config.before(:each) do
    DatabaseCleaner.start
    Notifiable.delivery_method = :send
    Notifiable.save_receipts = true
    Notifiable.notification_status_batch_size = 10_000
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

class MockNotifier < Notifiable::NotifierBase
  def enqueue(device_token, _notification)
    processed(device_token, 0)
  end
end

class ConfigurableMockNotifier < Notifiable::NotifierBase
  notifier_attribute :use_sandbox

  attr_reader :use_sandbox
end
