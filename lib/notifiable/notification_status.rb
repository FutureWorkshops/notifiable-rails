module Notifiable
  class NotificationStatus < ActiveRecord::Base
    
    belongs_to :localized_notification, :class_name => 'Notifiable::LocalizedNotification'
    validates :localized_notification, presence: true
    
    belongs_to :device_token, :class_name => 'Notifiable::DeviceToken'
    validates :device_token, presence: true
    
    self.table_name = 'notifiable_statuses'
    
    def opened!
      update_attribute(:status, -1)
       self.localized_notification.notification.increment!(:opened_count)
    end
    
    def opened?
      self.status == -1
    end
  end
end