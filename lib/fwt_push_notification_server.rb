require "fwt_push_notification_server/engine"
require 'active_support/core_ext/hash/slice'
require "devise"


module FwtPushNotificationServer

	mattr_accessor :config

	def self.apns_config
		config.slice(:gateway, :certificate, :passphrase)
	end

	def self.send_notification_to_all(alert)
		devices = DeviceToken.where(:is_valid => true).all
		send_notification(alert, devices)
	end

	def self.send_notification(alert, device_tokens)

      alert = alert.byteslice(0, 232)
      alert += '...' if alert.bytesize > 232
      
      config = self.apns_config
      
      pusher = Grocer.pusher(config)
      
      device_tokens = [device_tokens] unless device_tokens.is_a?(Array)

      device_tokens.each do |device|
      	if device.is_valid
        	token = device.token
      	 	n = Grocer::Notification.new(device_token: token, alert: alert)
        	pusher.push n
    	end
      end

      feedback = Grocer.feedback(config)
      feedback.each do |attempt|
        token = attempt.device_token
        device_token = DeviceToken.find_by_token(token)
        device_token.update_attribute("is_valid", false) unless device_token.nil?
        puts "Device #{token} failed at #{attempt.timestamp}"
      end

	end

end
