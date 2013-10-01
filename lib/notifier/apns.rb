module FwtPushNotificationServer

	module Notifier

		class APNS

			def notify(message, device_tokens)

				alert = message.byteslice(0, 232)
		     	alert += '...' if alert.bytesize > 232
		      
		     	config = FwtPushNotificationServer.apns_config
		     	pusher = Grocer.pusher(config)
		      
		     	device_tokens = [device_tokens] unless device_tokens.is_a?(Array)
				device_tokens.each do |device|
		      		if device.is_valid
		        		token = device.token
		      	 		n = Grocer::Notification.new(device_token: token, alert: alert)
		        		pusher.push n
		    	  	end
		      	end

		      	feedback = Grocer.feedback(config)
		      	feedback.each do |attempt|
		        	token = attempt.device_token
		        	device_token = DeviceToken.find_by_token(token)
		        	device_token.update_attribute("is_valid", false) unless device_token.nil?
		        	puts "APNS: Device #{token} failed at #{attempt.timestamp}"
		      	end

			end

		end

	end

end