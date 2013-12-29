module Notifiable

	module Notifier

		class Base
      def self.create(provider)
        case provider
        when :apns
          Notifiable.apns_class_name.constantize.new
        when :gcm
          Notifiable.gcm_class_name.constantize.new
        end
      end
      
			def send_notification(notification, device_token)
        # todo - add before hook
        enqueue(notification, device_token)
        # todo - add after hook       				
      end
      
      def close
        flush
      end
      
      protected
      def flush
        
      end
      
      def processed(notification, device_token)
        Notifiable::NotificationDeviceToken.create :notification => notification, :device_token => device_token
      end
		end

	end

end