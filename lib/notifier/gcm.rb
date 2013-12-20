module FwtPushNotificationServer

	module Notifier

		class GCM < Base
      
      def initialize
        @batch = {}
      end
      
      # todo should be made threadsafe
      protected 
			def enqueue(notification, device_token)
        @batch[notification] ||= [device_token]        								
        tokens = @batch[notification]
        if tokens.count >= 1000
          send_batch(notification, tokens)
        end
  		end
      
      def flush
        @batch.each_pair do |notification, device_tokens|
          send_batch(notifiction, device_tokens)
        end
      end

			private
			def send_batch(notification, device_tokens)
				gcm = ::GCM.new(FwtPushNotificationServer.gcm_api_key)
				response = gcm.send_notification(device_tokens.collect{|dt| dt.token}, {:data => {:message => notification.message}})
				body = JSON.parse(response.fetch(:body, "{}"))
				results = body.fetch("results", [])
				results.each_with_index do |result, idx|
					if result["error"]
						device_tokens[idx].update_attribute('is_valid', false)
          else
            processed(notification, device_tokens[idx])
          end
				end
        @batch[notification] = nil
			end

		end

	end

end