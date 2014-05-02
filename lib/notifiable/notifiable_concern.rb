module Notifiable
  module Concern
  	extend ActiveSupport::Concern

  	def send_notification(notification)
      notification.batch do |n|
        n.add_notifiable(self)
      end
  	end
  
  	def device_tokens
  		Notifiable::DeviceToken.where(:user_id => self.id)
  	end
  end
end