module Notifiable

	class NotifierBase
    
    attr_reader :env, :notification
    
    def self.notifier_attribute(*vars)
      @notifier_attributes ||= []
      @notifier_attributes.concat vars
      attr_writer(*vars)
    end
    
    def self.notifier_attributes
      @notifier_attributes
    end
    
    def initialize(notification)
      @notification = notification
    end
    
		def send_notification(device_token)
      enqueue(device_token, self.notification)
    end
    
    def close
      flush
      save_receipts if Notifiable.save_receipts
      @notification.save
    end
    
    protected    
      def flush
      
      end
    
      def processed(device_token, status, error_message = nil)
        if @notification.app.save_notification_statuses
          receipts << {notification_id: self.notification.id, device_token_id: device_token.id, status: status, created_at: DateTime.now, error_message: error_message}
          save_receipts if receipts.count >= Notifiable.notification_status_batch_size
        end
        
        @notification.sent_count += 1
        @notification.gateway_accepted_count += 1 if status == 0
        @notification.save if (@notification.sent_count % Notifiable.notification_status_batch_size == 0)
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