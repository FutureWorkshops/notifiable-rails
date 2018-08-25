begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
Bundler::GemHelper.install_tasks

namespace :db do
  task :env do
    require 'active_record'
    include ActiveRecord::Tasks
    DatabaseTasks.database_configuration = YAML.load_file('config/database.yml')
    DatabaseTasks.db_dir = 'db'
    ActiveRecord::Base.configurations = DatabaseTasks.database_configuration    
  end
  
  desc 'Create the database'
  task create: :env do
    DatabaseTasks.create_current('test')
  end
  
  desc 'Drop the database'
  task drop: :env do
    DatabaseTasks.drop_current('test')
  end
end

require 'rspec/core'
require 'rspec/core/rake_task'
namespace :ci do
  desc "Prepare the CI environment"
  task :prepare => ['db:drop', 'db:create', 'db:migrate']
  
  namespace :test do
    desc "Run all specs in spec directory (excluding plugin specs)"
    RSpec::Core::RakeTask.new(:spec)
  end
  
  desc "Run all CI tests"
  task :test => ['ci:test:spec']
end

task :default => ':ci:test'
