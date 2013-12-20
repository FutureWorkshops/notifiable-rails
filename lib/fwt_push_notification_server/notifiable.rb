module FwtPushNotificationServer
	module Notifiable
		extend ActiveSupport::Concern

		def send_notification(notification)
      FwtPushNotificationServer.batch do |b|
        b.add(notification, self)
      end
		end
    
		def device_tokens
			key = FwtPushNotificationServer.user_key
			FwtPushNotificationServer::DeviceToken.where(:user_id => send(key))
		end

	end
end