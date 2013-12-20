module FwtPushNotificationServer
  module Batch
    class Public < Base
      attr_accessor :notification  
      attr_accessor :device_tokens
      
      def initialize(options)
        super(options)
        @device_tokens = []
        @notification = options[:notification]
      end
    
      def add_user(user)
        user.device_tokens.each do |device_token|
          @device_tokens << device_token if device_token.is_valid
        end
      end
  
      def send_notifications
        @device_tokens.uniq!
        
        # turn device tokens into map
        tokens_map = {}
        @device_tokens.each do |device_token|
          provider_sym = device_token.provider.to_sym
          tokens_map[provider_sym] = [] if tokens_map[provider_sym].nil? 
          tokens_map[provider_sym] << device_token
        end
      
        tokens_map.each_pair do |provider, device_tokens|          
          notifier = @notifiers[provider]
          unless notifier.nil? 
      		  notifier.send_public_notifications(notification, device_tokens) 
            FwtPushNotificationServer.deliveries << self if FwtPushNotificationServer.delivery_method == :test
          end
        end        
      end
    end
  end
end