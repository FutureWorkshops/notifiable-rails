module FwtPushNotificationServer
  class Batch
    attr_accessor :notifiers
  
    def initialize
      @notifiers = {
        :apns => Notifier::APNS.new,
        :gcm => Notifier::GCM.new
      }
    end
    
    def add(notification, user)
      user.device_tokens.each do |d|
        notifier = @notifiers[d.provider.to_sym]
        if d.is_valid? && !notifier.nil? 
    		  notifier.send_notification(notification, d) 
        end
      end
    end
    
    def close
      @notifiers.each_value {|n| n.close}
      @notifiers = nil
    end
  end
end