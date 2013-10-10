module FwtPushNotificationServer
  
  class DeviceToken < ActiveRecord::Base
  
  	validates_uniqueness_of :token
    validates_presence_of :token
    validates_presence_of :provider

  	def user
  		user_id.blank? ? nil : FwtPushNotificationServer.user_class.find_or_create_by(FwtPushNotificationServer.user_key => user_id)
  	end

  	def notifier
  		return nil if provider.nil?
		  FwtPushNotificationServer.notifiers[provider.to_sym]
    end

  end

end
