module Notifiable
  class App < ActiveRecord::Base
    has_many :device_tokens, :class_name => 'Notifiable::DeviceToken', :dependent => :destroy
    has_many :notifications, :class_name => 'Notifiable::Notification', :dependent => :destroy
    
    serialize :configuration
    
    def configure(provider, notifier)
      return unless self.configuration && self.configuration[provider]
      
      self.configuration[provider].each_pair {|key, value| notifier.send("#{key}=", value) if notifier.methods.include?("#{key}=".to_sym) } 
    end
  end
end