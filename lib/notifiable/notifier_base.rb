module Notifiable

	class NotifierBase
    
    attr_reader :env, :notification
    
    def initialize(env, notification)
      @env, @notification = env, notification
    end
    
		def send_notification(device_token)
      localized_notification = self.localized_notification(device_token)
      enqueue(device_token, localized_notification) if localized_notification
    end
    
    def close
      flush
      save_receipts
    end
    
    protected    
      def flush
      
      end
      
      def localized_notification(device_token)
        self.notification.localized_notification(device_token.locale)
      end
    
      def processed(device_token, status)
        receipts << {localized_notification_id: self.localized_notification(device_token).id, device_token_id: device_token.id, status: status, created_at: DateTime.now}
      
        if receipts.count > Notifiable.notification_status_batch_size
          save_receipts
        end
      end
    
      def test_env?
        self.env == "test"
      end
    
    private
      def receipts
        @receipts ||= []
      end
    
      def save_receipts
        Notifiable::NotificationStatus.bulk_insert! receipts
        @receipts = []
      end
	end
end