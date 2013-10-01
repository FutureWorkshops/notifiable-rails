module FwtPushNotificationServer
  
  class DeviceToken < ActiveRecord::Base
  
  	validates_uniqueness_of :token

  	def user
  		user_id.blank? ? nil : FwtPushNotificationServer.user_class.find_by(FwtPushNotificationServer.user_key => user_id)
  	end

  end

end
