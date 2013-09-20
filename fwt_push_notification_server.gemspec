$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fwt_push_notification_server/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fwt_push_notification_server"
  s.version     = FwtPushNotificationServer::VERSION
  s.authors     = ["Kamil Kocemba"]
  s.email       = ["kamil@futureworkshops.com"]
  s.homepage    = "http://futureworkshops.com"
  s.summary     = "A simple rails plugin for APNS."
  s.description = "A simple rails plugin for managing device tokens and sending push notifications."
  s.licenses    = ["MIT"]

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.0.0"
  s.add_dependency "kaminari-bootstrap"
  s.add_dependency "bootstrap-sass"
  s.add_dependency "sass-rails"
  s.add_dependency "devise"
  s.add_dependency "cancan"
  s.add_dependency "simple_form"
  s.add_dependency "rails_bootstrap_navbar"
  s.add_dependency "coffee-rails"
  s.add_dependency "grocer"

  s.add_development_dependency "sqlite3"

end
