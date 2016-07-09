module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :params
    
    has_many :localized_notifications, :class_name => 'Notifiable::LocalizedNotification', :dependent => :destroy
    accepts_nested_attributes_for :localized_notifications, reject_if: proc { |attributes| attributes['message'].blank? }
    
    belongs_to :app, :class_name => 'Notifiable::App'    
    validates :app, presence: true
    
    def notification_statuses
      Notifiable::NotificationStatus.joins(:localized_notification).where('notifiable_localized_notifications.notification_id' => self.id)
    end
    
    def batch  
      yield(self)
      close
    end
    
    def localized_notification(locale)
      self.localized_notifications.find_by(:locale => locale)
    end
    
    def add_notifiable(notifiable)
      notifiable.device_tokens.each do |d|
        self.add_device_token(d)
      end
    end
    
    def add_device_token(d)
      provider = d.provider.to_sym

      unless notifiers[provider]
        clazz = Notifiable.notifier_classes[provider]
        raise "Notifier #{provider} not configured" unless clazz
        notifier = clazz.new(Rails.env, self)
        self.app.configure(provider, notifier)
        @notifiers[provider] = notifier
      end
      
  		notifiers[provider].send_notification(d) if d.is_valid?
    end
    
    def summarise
      self.sent_count = self.notification_statuses.count
      self.gateway_accepted_count = self.notification_statuses.where(:status => 0).count
      self.save
    end
    
    private
      def notifiers
        @notifiers ||= {}
      end
    
      def close
        notifiers.each_value {|n| n.close}
        @notifiers = nil
      end
  end
end