module Notifiable
  class DeviceToken < ActiveRecord::Base
    belongs_to :app, :class_name => "Notifiable::App"
    has_many :notification_statuses, :class_name => "Notifiable::NotificationStatus"
    
    validates_presence_of :token, :provider, :app
  end

end
