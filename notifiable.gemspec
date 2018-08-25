# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)

# Maintain your gem's version:
require 'notifiable/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'notifiable'
  s.version     = Notifiable::VERSION
  s.authors     = ['Matt Brooke-Smith']
  s.email       = ['matt@futureworkshops.com']
  s.homepage    = 'http://www.futureworkshops.com'
  s.summary     = 'Notifiable core classes.'
  s.licenses    = ['Apache 2.0']

  s.files = Dir['{db,lib}/**/*', 'LICENSE', 'Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.required_ruby_version = '>= 2.3.1'

  s.add_dependency 'activerecord'
  s.add_dependency 'activerecord-import'
  s.add_dependency 'activerecord-postgis-adapter'
  s.add_dependency 'pg'

  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_bot'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-rspec'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'simplecov-rcov'
end
