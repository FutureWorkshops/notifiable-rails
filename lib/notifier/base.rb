module FwtPushNotificationServer

	module Notifier

		class Base
			def send_public_notifications(notification, device_tokens = [])
        protected_send_public_notifications(notification, device_tokens)       				
      end
            
			def send_private_notifications(notifications, device_tokens = []) 
        throw "Not implemented"       
			end
		end

	end

end