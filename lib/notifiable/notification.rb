module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :payload
    
    has_many :notification_device_tokens, :class_name => 'Notifiable::NotificationDeviceToken'
    
    def provider_value(provider, key)
      if self.payload && self.payload[provider] && self.payload[provider][key]
        self.payload[provider][key]
      elsif self.respond_to? key
        self.send(key)
      end       
    end
  end
end