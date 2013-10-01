module FwtPushNotificationServer

	module Notifier

		class GCM < Notifier::Base

			def notify_once(message, device_tokens)

				device_tokens = [device_tokens] unless device_tokens.is_a?(Array)
				gcm = ::GCM.new(FwtPushNotificationServer.gcm_api_key)

				registration_ids = []
				payload = { :data => { :message => message } }
				device_tokens.each do |device|
					registration_ids << device.token
					if registration_ids.count == 1000
						response = gcm.send_notification(registration_ids, payload)
						puts response
						registration_ids = []
					end
				end

				response = gcm.send_notification(registration_ids, payload)
				puts response
			end

		end

	end

end