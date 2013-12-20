module FwtPushNotificationServer

	module Notifier

		class Base
			def notify_once(message, device_tokens = [], payload = nil)        
        send_notify_once(message, device_tokens, payload)  
			end
		end

	end

end