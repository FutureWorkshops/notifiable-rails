module Notifiable
  class NotificationStatus < ActiveRecord::Base
    belongs_to :notification, :class_name => 'Notifiable::Notification'
    belongs_to :device_token, :class_name => 'Notifiable::DeviceToken'
    
    self.table_name = 'notifiable_statuses'
    
    def opened!
      update_attribute(:status, -1)
    end
    
    def opened?
      self.status == -1
    end
  end
end