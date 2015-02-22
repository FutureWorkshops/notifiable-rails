module Notifiable
  class LocalizedNotification < ActiveRecord::Base
    validates :message, presence: true, allow_blank: false
    
    belongs_to :notification, :class_name => "Notifiable::Notification"
    #validates :notification, presence: true
    
    serialize :params
    
    has_many :notification_statuses, :class_name => 'Notifiable::NotificationStatus', :dependent => :destroy
    
    def send_params
      @send_params ||= (self.params ? self.params : {}).merge({:localized_notification_id => self.id})
    end
  end
end