module Notifiable
  class Batch
    attr_accessor :notifiers
    
    def initialize
      @notifiers = {}
    end
    
    def add(notification, user)
      user.device_tokens.each do |d|
        provider = d.provider.to_sym
        notifier = @notifiers[provider]
        
        unless notifier
          notifier = Notifier::Base.create provider
          @notifiers[provider] = notifier
        end
        
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