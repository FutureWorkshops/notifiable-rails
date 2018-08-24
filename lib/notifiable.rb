require 'notifiable/active_record'
require 'notifiable/app'
require 'notifiable/railtie' if defined?(Rails)
require 'notifiable/engine'
require 'notifiable/notification'
require 'notifiable/notification_status'
require 'notifiable/device_token'
require 'notifiable/notifier_base'

module Notifiable
  
  mattr_accessor :delivery_method
  @@delivery_method = :send
  
  mattr_accessor :save_receipts
  @@save_receipts = true
  
  mattr_accessor :notification_status_batch_size
  @@notification_status_batch_size = 10000
  
  mattr_accessor :notifier_classes
  @@notifier_classes = {}
  
  mattr_accessor :find_notifier_class
  @@find_notifier_class = nil
  
  def self.configure
    yield self
  end
  
  def self.notifier_class(notification, device)
    Notifiable.find_notifier_class ? Notifiable.find_notifier_class(notification, device) : Notifiable.notifier_classes[device.provider.to_sym]
  end
end