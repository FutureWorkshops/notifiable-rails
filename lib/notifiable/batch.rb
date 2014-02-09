module Notifiable
  class Batch
    attr_accessor :notifiers
    
    def initialize(config = {})
      @notifiers = {}
      @config = config
    end
    
    def add(notification, user)
      user.device_tokens.each do |d|
        provider = d.provider.to_sym
        
        unless @notifiers[provider]
          clazz = Notifiable.notifier_classes[provider]          
          raise "Notifier #{provider} not configured" unless clazz
          @notifiers[provider] = clazz.new
          @notifiers[provider].env = Notifiable.env
          @config[provider].each_pair {|key, value| @notifiers[provider].send("#{key}=", value) if @notifiers[provider].methods.include?("#{key}=".to_sym) } if @config[provider]
        end
        
        notifier = @notifiers[provider]
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