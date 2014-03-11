module Notifiable
  class DeviceToken < ActiveRecord::Base
    belongs_to :app, :class_name => "Notifiable::App"
    
    validates_presence_of :token, :provider, :app
  	validates_uniqueness_of :token

  	def user
  		user_id.blank? ? nil : Notifiable.user_class.find(user_id)
  	end
  end

end
