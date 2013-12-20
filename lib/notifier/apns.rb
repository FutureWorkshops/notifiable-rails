module FwtPushNotificationServer

	module Notifier

		class APNS < Notifier::Base
      
			protected      
			def do_send_public_notifications(notification, device_tokens = [])        				
        alert = notification.message
				if alert.bytesize > 232
          alert.byteslice(0, 229)
          alert += '...'
				  Rails.logger.warn("Truncated message: #{notification.message}")
        end

				device_tokens = [device_tokens] unless device_tokens.is_a?(Array)
				device_tokens.each do |device|
					grocer_pusher.push(Grocer::Notification.new(
            device_token: device.token, 
            alert: alert, 
            custom: notification.payload
          )) if device.is_valid
				end

        process_feedback unless FwtPushNotificationServer.delivery_method == :test
			end
      
      private 
      def grocer_pusher
        @grocer_pusher ||= Grocer.pusher(FwtPushNotificationServer.apns_gateway_config)
      end
      
      def grocer_feedback
				@grocer_feedback ||= Grocer.feedback(FwtPushNotificationServer.apns_feedback_config)
      end
      
      def process_feedback
				self.grocer_feedback.each do |attempt|
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