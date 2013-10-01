require "devise"
require "cancan"
require "grocer"
require "gcm"

module FwtPushNotificationServer
  
  class Engine < ::Rails::Engine
    isolate_namespace FwtPushNotificationServer
  end

end
