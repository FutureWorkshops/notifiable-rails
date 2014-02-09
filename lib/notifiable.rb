require 'notifiable/active_record'
require 'notifiable/notifiable_concern'
require 'notifiable/railtie' if defined?(Rails)
require 'notifiable/engine'
require 'notifiable/notification'
require 'notifiable/notification_device_token'
require 'notifiable/batch'
require 'notifiable/device_token'
require 'notifiable/notifier_base'

module Notifiable

  mattr_accessor :api_controller_class

  mattr_accessor :user_class
  
  mattr_accessor :delivery_method
  @@delivery_method = :send
  
  mattr_accessor :notifier_classes
  @@notifier_classes = {}
  
  def self.configure
    yield self
  end
  
  def self.batch(config = {})    
    b = Batch.new(config)
    yield(b)
    b.close
  end
  
  def self.env
    Rails.env || 'development'
  end

end

module Notifiable
  module Model
    def notifiable(options = {})
      include Notifiable::Concern
    end
  end
end
