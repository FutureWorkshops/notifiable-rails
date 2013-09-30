require "devise"
require "cancan"
require "grocer"

module FwtPushNotificationServer
  
  class Engine < ::Rails::Engine
    isolate_namespace FwtPushNotificationServer
  end

end
