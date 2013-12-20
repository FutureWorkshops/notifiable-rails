module FwtPushNotificationServer
  class Notification
    attr_accessor :message
    attr_accessor :payload
    
    def initialize(options = {})
      options.each {|k,v| instance_variable_set("@#{k}",v)}
    end
  end
end