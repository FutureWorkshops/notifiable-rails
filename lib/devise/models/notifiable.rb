module Devise
	module Models

		module Notifiable

			extend ActiveSupport::Concern

			def notify_once(message, payload = nil)
				device_tokens.each do |dt|
					dt.notifier.notify_once(message, [dt], payload) if dt.is_valid && !dt.notifier.nil?
				end
			end
      
			def schedule_notification
				device_tokens.each do |dt|
					dt.notifier.add_device_token(dt) if dt.is_valid && !dt.notifier.nil?
				end
			end

			def device_tokens
				key = FwtPushNotificationServer.user_key
				FwtPushNotificationServer::DeviceToken.where(:user_id => send(key))
			end

		end

	end
end