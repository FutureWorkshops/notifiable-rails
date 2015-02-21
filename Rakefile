begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end

Bundler::GemHelper.install_tasks

APP_RAKEFILE = File.expand_path("../spec/test_app/Rakefile", __FILE__)
load 'rails/tasks/engine.rake'

Dir[File.join(File.dirname(__FILE__), 'lib/tasks/**/*.rake')].each {|f| load f }

require 'rspec/core'
require 'rspec/core/rake_task'

namespace :ci do
  desc "Prepare the CI environment"
  task :prepare => ['db:drop', 'db:create', 'db:migrate']
  
  namespace :test do
    desc "Run all specs in spec directory (excluding plugin specs)"
    RSpec::Core::RakeTask.new(:spec)
  
    desc "Run Brakeman security tests"
    task :security => ['brakeman:run']
  end
  
  desc "Run all CI tests"
  task :test => ['ci:test:spec', 'ci:test:security']
end

task :default => ':ci:test'
