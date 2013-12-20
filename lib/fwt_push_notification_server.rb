require 'notifier/base'
require 'notifier/apns'
require 'notifier/gcm'

require 'fwt_push_notification_server/notifiable'
require 'fwt_push_notification_server/railtie' if defined?(Rails)
require 'fwt_push_notification_server/engine'
require 'fwt_push_notification_server/notification'
require 'fwt_push_notification_server/batch/base'
require 'fwt_push_notification_server/batch/public'
require 'fwt_push_notification_server/batch/private'
require 'fwt_push_notification_server/device_token'


module FwtPushNotificationServer

  mattr_accessor :api_controller_class

  mattr_accessor :user_class

  mattr_accessor :permitted_user_attributes

  mattr_accessor :user_key
  @@user_key = :user_id  

  mattr_accessor :apns_gateway
  @@apns_gateway = 'sandbox.push.apple.com'

  mattr_accessor :apns_certificate

  mattr_accessor :apns_passphrase

  mattr_accessor :gcm_api_key
  
  mattr_accessor :delivery_method
  @@delivery_method = :send

  def self.configure
    yield self
  end

  mattr_accessor :deliveries
  @@deliveries = []

  def self.apns_config
    {
      :gateway => apns_gateway,
      :certificate => apns_certificate,
      :passphrase => apns_passphrase
    }
  end

  def self.begin_transaction(message, payload = nil)
    notifiers.each_value do |notifier|
      notifier.begin_transaction(message, payload)
    end
    yield
    notifiers.each_value do |notifier|
      notifier.commit_transaction
    end
  end
end

module FwtPushNotificationServer
  module Model
    def notifiable(options = {})
      include Notifiable
    end
  end
end
