# frozen_string_literal: true

module Notifiable
  class App < ActiveRecord::Base
    self.table_name_prefix = 'notifiable_'

    has_many :device_tokens, class_name: 'Notifiable::DeviceToken', dependent: :destroy
    has_many :notifications, class_name: 'Notifiable::Notification', dependent: :destroy

    serialize :configuration

    validates :name, presence: true, allow_blank: false

    def configure(provider, notifier)
      return unless configuration && configuration[provider]

      configuration[provider].each_pair { |key, value| notifier.instance_variable_set("@#{key}", value) if notifier.class.notifier_attributes.include?(key) }
    end

    def configuration
      unless read_attribute(:configuration)
        write_attribute(:configuration, default_configuration)
      end
      read_attribute(:configuration)
    end

    def default_configuration
      configuration = {}
      Notifiable.notifier_classes.each_pair do |provider, clazz|
        configuration[provider] = {}
        next unless clazz.notifier_attributes
        clazz.notifier_attributes.each do |notifier_attribute|
          configuration[provider][notifier_attribute] = nil
        end
      end
      configuration
    end

    def self.define_configuration_accessors(notifiers)
      notifiers.each_pair do |provider, clazz|
        next unless clazz.notifier_attributes

        clazz.notifier_attributes.each do |attribute|
          define_method("#{provider}_#{attribute}=") { |v| configuration[provider][attribute] = v }
          define_method("#{provider}_#{attribute}") { configuration[provider][attribute] }
        end
      end
    end

    def save_notification_statuses
      configuration[:save_notification_statuses] == true || configuration[:save_notification_statuses].eql?('1')
    end

    def save_notification_statuses=(save_notification_statuses)
      configuration[:save_notification_statuses] = save_notification_statuses
    end
  end
end
