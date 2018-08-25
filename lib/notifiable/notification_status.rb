module Notifiable
  class NotificationStatus < ActiveRecord::Base
    self.table_name_prefix = 'notifiable_'
    
    belongs_to :notification, :class_name => 'Notifiable::Notification'
    validates :notification, presence: true
    
    belongs_to :device_token, :class_name => 'Notifiable::DeviceToken'
    validates :device_token, presence: true
    
    self.table_name = 'notifiable_statuses'
    
    def opened!
      update_attribute(:status, -1)
       self.notification.increment!(:opened_count)
    end
    
    def opened?
      self.status == -1
    end
  end
end