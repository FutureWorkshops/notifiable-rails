module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :params
    
    has_many :notification_status, :class_name => 'Notifiable::NotificationStatus'
  end
end