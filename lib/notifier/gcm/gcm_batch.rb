module Notifiable
	module Notifier
    module GCM
  		class GCMBatch < Base
      
        # todo should be made threadsafe
        protected 
  			def enqueue(notification, device_token)
          @batch ||= {}
          @batch[notification.message] = [] if @batch[notification].nil?
          @batch[notification.message] << device_token        								
          tokens = @batch[notification.message]
          if tokens.count >= Notifiable.gcm_batch_size
            send_batch(notification, tokens)
          end
    		end
      
        def flush
          @batch.each_pair do |notification, device_tokens|
            send_batch(notification, device_tokens)
          end
        end

  			private
  			def send_batch(notification, device_tokens)
          if Notifiable.delivery_method == :test || Notifiable.env == 'test'
            device_tokens.each {|d| processed(notification, d)}
          else
    				gcm = ::GCM.new(Notifiable.gcm_api_key)
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
          end
          @batch[notification] = nil
  			end
  		end
    end
	end
end