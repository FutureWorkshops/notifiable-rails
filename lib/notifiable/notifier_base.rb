module Notifiable

	class NotifierBase
    
    attr_accessor :env
    
		def send_notification(notification, device_token)
      # todo - add before hook
      enqueue(notification, device_token, custom_params(notification))
      # todo - add after hook       				
    end
    
    def close
      flush
      save_receipts
    end
    
    protected    
    def flush
      
    end
    
    def processed(notification, device_token, status)
      receipts << {notification_id: notification.id, device_token_id: device_token.id, status: status, created_at: DateTime.now}
      
      if receipts.count > 10000
        save_receipts
      end
    end
    
    def custom_params(notification)
      params = notification.params || {}
      params[:notification_id] = notification.id
      params
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