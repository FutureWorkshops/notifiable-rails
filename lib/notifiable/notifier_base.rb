module Notifiable

	class NotifierBase
    
    attr_reader :env, :notification, :localized_notifications
    
    def initialize(env, notification)
      @env, @notification = env, notification
      @localized_notifications = {}
      notification.localized_notifications.each{|l| @localized_notifications[l.locale] = l}
    end
    
		def send_notification(device_token)
      localized_notification = self.localized_notification(device_token)
      enqueue(device_token, localized_notification) if localized_notification
    end
    
    def close
      flush
      save_receipts if Notifiable.save_receipts
      @notification.save
    end
    
    protected    
      def flush
      
      end
      
      def localized_notification(device_token)
        @localized_notifications[device_token.locale]
      end
    
      def processed(device_token, status)
        if @notification.app.save_notification_statuses?
          receipts << {localized_notification_id: self.localized_notification(device_token).id, device_token_id: device_token.id, status: status, created_at: DateTime.now}
          save_receipts if receipts.count >= Notifiable.notification_status_batch_size
        end
        
        @notification.sent_count += 1
        @notification.gateway_accepted_count += 1 if status == 0
        @notification.save if (@notification.sent_count % Notifiable.notification_status_batch_size == 0)
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