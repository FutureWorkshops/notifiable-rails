module Devise
	module Models

		module Notifiable

			extend ActiveSupport::Concern

			def notify_once(message, payload = nil)
				device_tokens.each do |device|
					next unless device.is_valid
					device.notifier.notify_once(message, device, payload) unless device.notifier.nil?
				end
			end

			def schedule_notification
				device_tokens.each do |device|
					next unless device.is_valid
					device.notifier.add_device_token(device) unless device.notifier.nil?
				end
			end

			def device_tokens
				key = FwtPushNotificationServer.user_key
				FwtPushNotificationServer::DeviceToken.where(:user_id => send(key))
			end

		end

	end
end