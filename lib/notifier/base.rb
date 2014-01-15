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
        save_receipts
      end
      
      protected
      def flush
        
      end
      
      def processed(notification, device_token)
        receipts << {:notification_id => notification.id, :device_token_id => device_token.id }
        
        if receipts.count > 10000
          save_receipts
        end
      end
      
      private
      def receipts
        @receipts ||= []
      end
      
      def save_receipts
        Notifiable::NotificationDeviceToken.bulk_insert! receipts
        @receipts = []
      end
		end

	end

end