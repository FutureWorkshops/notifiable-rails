module Notifiable::Concern
	extend ActiveSupport::Concern

	def send_notification(notification)
    Notifiable.batch do |b|
      b.add(notification, self)
    end
	end
  
	def device_tokens
		Notifiable::DeviceToken.where(:user_id => self.id)
	end
end