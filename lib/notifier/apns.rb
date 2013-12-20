module FwtPushNotificationServer

	module Notifier

		class APNS < Base
      
      def close
        super
        @grocer_pusher = nil        
        @grocer_feedback = nil
      end
      
			protected      
			def enqueue(notification, device_token)        				
          
        grocer_notification = Grocer::Notification.new(device_token: device_token.token, alert: notification.apns_message, custom: notification.payload)
				grocer_pusher.push(grocer_notification) unless FwtPushNotificationServer.delivery_method == :test

        processed(notification, device_token)
			end
      
      def flush
        process_feedback unless FwtPushNotificationServer.env == 'test'
      end

      private 
      def grocer_pusher
        @grocer_pusher ||= Grocer.pusher(FwtPushNotificationServer.apns_gateway_config)
      end
      
      def grocer_feedback
				@grocer_feedback ||= Grocer.feedback(FwtPushNotificationServer.apns_feedback_config)
      end
      
      def process_feedback
				grocer_feedback.each do |attempt|
					token = attempt.device_token
					device_token = DeviceToken.find_by_token(token)
					if device_token
						device_token.update_attribute("is_valid", false) if device_token.updated_at < attempt.timestamp
						Rails.logger.info("Device #{token} (#{device_token.user_id}) failed at #{attempt.timestamp}")
					end
				end
      end
		end

	end

end