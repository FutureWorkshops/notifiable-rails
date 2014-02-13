module Notifiable
  class NotificationStatus < ActiveRecord::Base
    belongs_to :notification, :class_name => 'Notifiable::Notification'
    belongs_to :device_token, :class_name => 'Notifiable::DeviceToken'
  end
end