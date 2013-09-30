module Devise
	module Models

		module Notifiable

			extend ActiveSupport::Concern

			def notify(message, provider = :apns)
				if provider == :apns
					notifier = FwtPushNotificationServer::Notifier::APNS.new
				elsif provider == :gcm
					notifier = FwtPushNotificationServer::Notifier::GCM.new
				end
				notifier.notify(message, device_token) unless notifier.nil?
			end

			def device_token
				FwtPushNotificationServer::DeviceToken.find_by_user(self)
			end

		end

	end
end