module Notifiable
  module Concern
  	extend ActiveSupport::Concern

  	def send_notification(notification)
      Notifiable.batch do |b|
        b.add_notifiable(notification, self)
      end
  	end
  
  	def device_tokens
  		Notifiable::DeviceToken.where(:user_id => self.id)
  	end
  end
end