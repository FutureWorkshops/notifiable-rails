module FwtPushNotificationServer
  module Batch
    class Private < Base
      attr_accessor :device_tokens
      attr_accessor :messages
      attr_accessor :payloads
      
      def initialize()
        @device_tokens = []
      end
    
      def add_notification(user, notification)
        
      end
  
      def send
        # uniq all device_tokens and turn into map
        tokens_map = {:apns => [], :gcm => []}
        @device_tokens.uniq.each do |device_token|
          tokens_map[device_token.provider.to_sym] << device_token
        end
      
        tokens_map.each_pair do |provider, device_tokens|
          next if device_tokens.empty?
        
          if FwtPushNotificationServer.delivery_method == :test
            FwtPushNotificationServer.deliveries << self
          else
            notifier = @notifiers[provider]
        		notifier.notify_once(@message, device_tokens, @payload) unless notifier.nil?          
          end
        
        end
      end
    end
  end
end