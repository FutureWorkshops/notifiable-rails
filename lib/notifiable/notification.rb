module Notifiable
  class Notification < ActiveRecord::Base
    
    serialize :params
    
    has_many :notification_statuses, :class_name => 'Notifiable::NotificationStatus', :dependent => :destroy
    belongs_to :app, :class_name => 'Notifiable::App'
    
    validates_presence_of :app
    
    def batch  
      yield(self)
      close
    end
    
    def add_notifiable(notifiable)
      notifiable.device_tokens.each do |d|
        self.add_device_token(d)
      end
    end
    
    def add_device_token(d)
      provider = d.provider.to_sym

      if notifiers[provider].nil?
        clazz = Notifiable.notifier_classes[provider]          
        raise "Notifier #{provider} not configured" unless clazz
        
        notifier = clazz.new(Rails.env, self)
        self.app.configure provider, notifier
        
        notifiers[provider] = notifier
      end
      
      notifiers[provider].send_notification(d)  		  
    end
    
    def send_params
      @send_params ||= (self.params ? self.params : {}).merge({:notification_id => self.id})
    end
    
    private
      def notifiers
        @notifiers ||= {}
      end
    
      def close
        notifiers.each_value {|n| n.close}
        @notifiers = nil
        summarise
      end
    
      def summarise
        self.sent_count = self.notification_statuses.count
        self.gateway_accepted_count = self.notification_statuses.where(:status => 0).count
        self.save
      end
  end
end