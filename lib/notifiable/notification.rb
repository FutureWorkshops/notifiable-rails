module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :params
    
    has_many :notification_statuses, :class_name => 'Notifiable::NotificationStatus', :dependent => :destroy
  end
end