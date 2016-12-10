module Notifiable
  class Notification < ActiveRecord::Base
          
    belongs_to :app, :class_name => 'Notifiable::App'    
    validates :app, presence: true
    
    serialize :parameters
    
    has_many :notification_statuses, :class_name => 'Notifiable::NotificationStatus', :dependent => :destroy
    
    def batch  
      yield(self)
      close
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
    
    def send_params
      @send_params ||= (self.parameters ? self.parameters : {}).merge({:n_id => self.id})
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