$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "notifiable/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "notifiable-rails"
  s.version     = Notifiable::VERSION
  s.authors     = ["Kamil Kocemba", "Matt Brooke-Smith"]
  s.email       = ["kamil@futureworkshops.com", "matt@futureworkshops.com"]
  s.homepage    = "http://www.futureworkshops.com"
  s.summary     = "Notifiable engine for Rails."
  s.description = "Notifiable engine for Rails."
  s.licenses    = ["Apache 2.0"]

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.required_ruby_version = '~> 2.1.0'

  s.add_dependency "rails", "~> 4.1.0"

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'brakeman'
  
  # DB adapters & Load Test Tasks
  s.add_development_dependency 'puppet'
  s.add_development_dependency 'ruby-prof'
  #s.add_development_dependency 'mysql2'
  #s.add_development_dependency 'pg'

end
