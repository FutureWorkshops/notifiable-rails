require "kaminari-bootstrap"
require "bootstrap-sass"
require "sass-rails"
require "devise"
require "cancan"
require "simple_form"
require "rails_bootstrap_navbar"
require "coffee-rails"

module FwtPushNotificationServer
  
  class Engine < ::Rails::Engine
    isolate_namespace FwtPushNotificationServer
  end

end
