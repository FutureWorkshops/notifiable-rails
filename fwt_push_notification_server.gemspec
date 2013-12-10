$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fwt_push_notification_server/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fwt_push_notification_server"
  s.version     = FwtPushNotificationServer::VERSION
  s.authors     = ["Kamil Kocemba"]
  s.email       = ["kamil@futureworkshops.com"]
  s.homepage    = "http://www.futureworkshops.com"
  s.summary     = "Rails engine to make push notifications a bit easier."
  s.description = "Rails engine to make push notifications a bit easier. "
  s.licenses    = ["Apache 2.0"]

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "cancan"
  s.add_dependency "devise"

  s.add_dependency "grocer"
  s.add_dependency "gcm"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'debugger'

end
