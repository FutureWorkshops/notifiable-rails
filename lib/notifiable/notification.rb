module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :params
    
    has_many :notification_device_tokens, :class_name => 'Notifiable::NotificationDeviceToken'
  end
end