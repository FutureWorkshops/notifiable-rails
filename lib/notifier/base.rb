module FwtPushNotificationServer

	module Notifier

		class Base

			def begin_transaction(message, payload = nil)
				@device_tokens = []
				@message = message
				@payload = payload
			end

			def add_device_token(device_token)
				@device_tokens << device_token if device_token.is_valid
			end

			def commit_transaction
				notify_once(@message, @device_tokens.uniq, @payload)
			end

			def notify_once(message, device_tokens, payload = nil)
        return if device_tokens.empty?
        
        if FwtPushNotificationServer.delivery_method == :test
          n = FwtPushNotificationServer::Notification.new
          n.message = message
          n.device_tokens = device_tokens
          FwtPushNotificationServer.deliveries << n
        else
          send_notify_once(message, device_tokens, payload)  
        end
			end
		end

	end

end