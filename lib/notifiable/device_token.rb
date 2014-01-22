module Notifiable
  
  class DeviceToken < ActiveRecord::Base
    
  	validates_uniqueness_of :token
    validates_presence_of :token
    validates_presence_of :provider


  	def user
  		user_id.blank? ? nil : Notifiable.user_class.find(user_id)
  	end
  end

end
