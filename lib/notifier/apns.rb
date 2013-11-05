module FwtPushNotificationServer

	module Notifier

		class APNS < Notifier::Base

			def notify_once(message, device_tokens, payload = nil)

				alert = message.byteslice(0, 232)
		     	alert += '...' if alert.bytesize > 232
		      
		     	config = FwtPushNotificationServer.apns_config
		     	pusher = Grocer.pusher(config)
		      
		     	device_tokens = [device_tokens] unless device_tokens.is_a?(Array)
				device_tokens.each do |device|
		      		if device.is_valid
		        		token = device.token
		      	 		n = Grocer::Notification.new(device_token: token, alert: alert, custom: payload)
		        		pusher.push n
		    	  	end
		      	end

		      	feedback_config = {
		      		:gateway => config[:gateway].gsub('gateway', 'feedback'),
		      		:certificate => config[:certificate]
		      	}
		      	feedback = Grocer.feedback(feedback_config)
		      	feedback.each do |attempt|
		        	token = attempt.device_token
		        	device_token = DeviceToken.find_by_token(token)
		        	if device_token
			        	device_token.update_attribute("is_valid", false) if device_token.updated_at < attempt.timestamp
		        		Rails.logger.warn("APNS: Device #{token} (#{device_token.user_id}) failed at #{attempt.timestamp}")
		        	end
		      	end

			end

		end

	end

end