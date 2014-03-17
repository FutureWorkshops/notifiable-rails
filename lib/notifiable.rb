require 'notifiable/active_record'
require 'notifiable/app'
require 'notifiable/notifiable_concern'
require 'notifiable/railtie' if defined?(Rails)
require 'notifiable/engine'
require 'notifiable/notification'
require 'notifiable/notification_status'
require 'notifiable/batch'
require 'notifiable/device_token'
require 'notifiable/notifier_base'

module Notifiable

  mattr_accessor :api_controller_class
  
  mattr_accessor :api_device_token_params
  @@api_device_token_params = [:device_id, :token, :provider, :app_id]
  
  mattr_accessor :user_class
  
  mattr_accessor :delivery_method
  @@delivery_method = :send
  
  mattr_accessor :notifier_classes
  @@notifier_classes = {}
  
  def self.configure
    yield self
  end
  
  def self.batch(app = Notifiable::App.first)    
    b = Batch.new(app)
    yield(b)
    b.close
  end

end

module Notifiable
  module Model
    def notifiable(options = {})
      include Notifiable::Concern
    end
  end
end
