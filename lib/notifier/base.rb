module Notifiable

	module Notifier

		class Base
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
        Notifiable.deliveries << {:notification => notification, :device_token => device_token}
      end
		end

	end

end