module Notifiable
  class NotificationStatus < ActiveRecord::Base
    belongs_to :notification, :class_name => 'Notifiable::Notification'
    belongs_to :device_token, :class_name => 'Notifiable::DeviceToken'
    
    def opened!
      update_attributes({:status => -1, :uuid => nil})
    end
    
    def opened?
      self.status == -1
    end
  end
end