module Notifiable
  class App < ActiveRecord::Base
    has_many :device_tokens, :class_name => 'Notifiable::DeviceToken', :dependent => :destroy
    has_many :notifications, :class_name => 'Notifiable::Notification', :dependent => :destroy
    
    serialize :configuration
  end
end