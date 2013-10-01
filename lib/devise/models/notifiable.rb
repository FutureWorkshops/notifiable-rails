module Devise
	module Models

		module Notifiable

			extend ActiveSupport::Concern

			def notify(message)

				device_tokens.each do |device|
					next if device.provider.nil?
					provider = device.provider.to_sym

					if provider == :apns
						notifier = FwtPushNotificationServer::Notifier::APNS.new
					elsif provider == :gcm
						notifier = FwtPushNotificationServer::Notifier::GCM.new
					end

					notifier.notify(message, device_token) unless notifier.nil?
				end

			end

			def device_tokens
				key = FwtPushNotificationServer.user_key
				FwtPushNotificationServer::DeviceToken.where(:user_id => send(key))
			end

		end

	end
end