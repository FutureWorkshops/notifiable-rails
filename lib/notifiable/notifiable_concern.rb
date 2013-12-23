module Notifiable::Concern
	extend ActiveSupport::Concern

	def send_notification(notification)
    Notifiable.batch do |b|
      b.add(notification, self)
    end
	end
  
	def device_tokens
		key = Notifiable.user_key
		Notifiable::DeviceToken.where(:user_id => send(key))
	end
end