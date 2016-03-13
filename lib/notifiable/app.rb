module Notifiable
  class App < ActiveRecord::Base
    has_many :device_tokens, :class_name => 'Notifiable::DeviceToken', :dependent => :destroy
    has_many :notifications, :class_name => 'Notifiable::Notification', :dependent => :destroy
    
    serialize :configuration
    
    def configure(provider, notifier)
      return unless self.configuration && self.configuration[provider]

      self.configuration[provider].each_pair {|key, value| notifier.instance_variable_set("@#{key}", value) if notifier.class.notifier_attributes.include?(key) } 
    end
    
    def configuration
      unless read_attribute(:configuration)
        write_attribute(:configuration, default_configuration)
      end
      read_attribute(:configuration)
    end
    
    def default_configuration
      configuration = {}
      Notifiable.notifier_classes.each_pair do |provider,clazz|
        configuration[provider] = {}
        next unless clazz.notifier_attributes
        clazz.notifier_attributes.each do |notifier_attribute|
          configuration[provider][notifier_attribute] = nil
        end
      end
      configuration
    end
    
    def save_notification_statuses?
      self.configuration[:save_notification_statuses].nil? ? true : self.configuration[:save_notification_statuses]
    end
    
    def save_notification_statuses=(save_notification_statuses)
      self.configuration[:save_notification_statuses] = save_notification_statuses
    end
    
  end
end