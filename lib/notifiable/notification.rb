module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :params
    
    has_many :notification_statuses, :class_name => 'Notifiable::NotificationStatus', :dependent => :destroy
    belongs_to :app, :class_name => 'Notifiable::App'
    
    validates_presence_of :app
  end
end