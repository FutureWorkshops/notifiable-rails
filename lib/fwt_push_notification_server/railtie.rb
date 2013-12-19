require 'rails'

module FwtPushNotificationServer
  class Railtie < Rails::Railtie
    initializer 'fwtpushnotificationserver.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, FwtPushNotificationServer::Model
      end
    end
  end
end