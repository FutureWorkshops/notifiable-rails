module FwtPushNotificationServer
  module Batch
    class Public < Base
      attr_accessor :notification  
      attr_accessor :device_tokens
      
      def initialize(options)
        @device_tokens = []
        @notification = options[:notification]
      end
    
      def add_user(user)
        user.device_tokens.each do |device_token|
          @device_tokens << device_token if device_token.is_valid
        end
      end
  
      def send
        @device_tokens.uniq!
        
        # turn device tokens into map
        tokens_map = {}
        @device_tokens.each do |device_token|
          provider_sym = device_token.provider.to_sym
          tokens_map[provider_sym] = [] if tokens_map[provider_sym].nil? 
          tokens_map[provider_sym] << device_token
        end
      
        tokens_map.each_pair do |provider, device_tokens|
          next if device_tokens.empty?
        
          if FwtPushNotificationServer.delivery_method == :test
            FwtPushNotificationServer.deliveries << self
          else
            notifier = @notifiers[provider]
        		notifier.notify_once(notification.message, device_tokens, notification.payload) unless notifier.nil?          
          end
        end        
      end
    end
  end
end