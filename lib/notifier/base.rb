module FwtPushNotificationServer

	module Notifier

		class Base

			def begin_transaction(message)
				@device_tokens = []
				@message = message
			end

			def add_device_token(device_token)
				@device_tokens << device_token
			end

			def commit_transaction
				notify_once(@message, @device_tokens.uniq)
			end

			def notify_once(message, device_tokens)

			end

		end

	end

end