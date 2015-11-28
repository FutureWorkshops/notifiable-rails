require 'notifiable/active_record'
require 'notifiable/app'
require 'notifiable/notifiable_concern'
require 'notifiable/railtie' if defined?(Rails)
require 'notifiable/engine'
require 'notifiable/notification'
require 'notifiable/localized_notification'
require 'notifiable/notification_status'
require 'notifiable/device_token'
require 'notifiable/notifier_base'

module Notifiable

  mattr_accessor :api_controller_class
  
  mattr_accessor :api_device_token_params
  @@api_device_token_params = [:token, :provider, :app_id, :locale, :name]

  mattr_accessor :locales
  @@locales = [:en]
  
  mattr_accessor :user_class
  
  mattr_accessor :delivery_method
  @@delivery_method = :send
  
  mattr_accessor :save_receipts
  @@save_receipts = true
  
  mattr_accessor :notification_status_batch_size
  @@notification_status_batch_size = 10000
  
  mattr_accessor :notifier_classes
  @@notifier_classes = {}
  
  def self.configure
    yield self
  end

end

module Notifiable
  module Model
    def notifiable(options = {})
      include Notifiable::Concern
    end
  end
end
