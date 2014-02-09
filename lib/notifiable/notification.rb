module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :payload
    
    has_many :notification_device_tokens, :class_name => 'Notifiable::NotificationDeviceToken'
    
  end
end