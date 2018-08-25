# frozen_string_literal: true

module Notifiable
  class Notification < ActiveRecord::Base
    self.table_name_prefix = 'notifiable_'

    belongs_to :app, class_name: 'Notifiable::App'
    validates :app, presence: true

    serialize :parameters

    has_many :notification_statuses, class_name: 'Notifiable::NotificationStatus', dependent: :destroy

    def batch
      yield(self)
      update(last_error_message: nil)
    rescue Exception => e
      update(last_error_message: e.message)
    ensure
      close
    end

    def add_device_token(d)
      provider = d.provider.to_sym

      unless notifiers[provider]
        clazz = Notifiable.notifier_class(self, d)
        raise "Notifier #{provider} not configured" unless clazz
        notifier = clazz.new(self)
        app.configure(provider, notifier)
        @notifiers[provider] = notifier
      end

      notifiers[provider].send_notification(d)
    end

    def send_params
      @send_params ||= (parameters || {}).merge(n_id: id)
    end

    private

    def notifiers
      @notifiers ||= {}
    end

    def close
      notifiers.each_value(&:close)
      @notifiers = nil
    end
  end
end
