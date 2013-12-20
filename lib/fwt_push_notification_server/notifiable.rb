module FwtPushNotificationServer
	module Notifiable
		extend ActiveSupport::Concern

		def notify_once(notification)
      FwtPushNotificationServer::Batch::Public.begin(:notification => notification) do |n|
        n.add_user(self)
      end
		end
    
		def device_tokens
			key = FwtPushNotificationServer.user_key
			FwtPushNotificationServer::DeviceToken.where(:user_id => send(key))
		end

	end
end