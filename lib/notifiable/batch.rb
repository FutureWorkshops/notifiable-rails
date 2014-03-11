module Notifiable
  class Batch
    
    def initialize(app)
      raise "Must specify Notifiable::App" unless app
      @app = app
      @notifiers = {}
      @notification_ids = []
    end
    
    def add_notifiable(notification, notifiable)
      notifiable.device_tokens.each do |d|
        self.add_device_token(notification, d)
      end
    end
    
    def add_device_token(notification, d)
      provider = d.provider.to_sym

      unless @notifiers[provider]
        clazz = Notifiable.notifier_classes[provider]          
        raise "Notifier #{provider} not configured" unless clazz
        @notifiers[provider] = clazz.new
        @notifiers[provider].env = Rails.env
        
        if @app.configuration && @app.configuration[provider]
          @app.configuration[provider].each_pair {|key, value| @notifiers[provider].send("#{key}=", value) if @notifiers[provider].methods.include?("#{key}=".to_sym) } 
        end
      end
      
      notifier = @notifiers[provider]
      if d.is_valid? && !notifier.nil? 
  		  notifier.send_notification(notification, d)
        @notification_ids << notification.id
      end
    end
    
    def close
      @notifiers.each_value {|n| n.close}
      @notifiers = nil
      summarise
    end
    
    private
    def summarise
      notifications = Notification.where(:id => @notification_ids)
      notifications.each do |n|
        n.sent_count = n.notification_statuses.count
        n.gateway_accepted_count = n.notification_statuses.where(:status => 0).count
        n.save
      end
    end 
  end
end