module FwtPushNotificationServer
  
  class DeviceToken < ActiveRecord::Base
  
  	validates_uniqueness_of :token

  end

end
