require 'embedded_localization'

module Notifiable
  class Notification < ActiveRecord::Base
    
    has_many :notification_device_tokens, :class_name => 'Notifiable::NotificationDeviceToken'
    
    translates :message
    
    def localized_provider_message(device_token)
      device_token.user && device_token.user.locale ? message(device_token.user.locale.to_sym) : message
    end
  end
end