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

  mattr_accessor :apns_gateway
  @@apns_gateway = 'gateway.push.apple.com'

  mattr_accessor :apns_certificate

  mattr_accessor :apns_passphrase

  mattr_accessor :gcm_api_key

  mattr_accessor :gcm_batch_size
  @@gcm_batch_size = 1000
  
  mattr_accessor :delivery_method
  @@delivery_method = :send
  
  mattr_accessor :notifier_classes
  @@notifier_classes = {}
  
  def self.configure
    yield self
  end

  def self.apns_gateway_config
    {
      :gateway => apns_gateway,
      :certificate => apns_certificate,
      :passphrase => apns_passphrase
    }
  end
  
  def self.apns_feedback_config
    {
      :gateway => self.apns_gateway_config[:gateway].gsub('gateway', 'feedback'),
      :certificate => self.apns_gateway_config[:certificate],
      :passphrase => self.apns_gateway_config[:passphrase]
    }
  end
  
  def self.batch()
    b = Batch.new
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
