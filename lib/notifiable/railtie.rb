require 'rails'

module Notifiable
  class Railtie < Rails::Railtie
    initializer 'Notifiable.initialize' do
      ActiveSupport.on_load(:active_record) do
        ActiveRecord::Base.send :extend, Notifiable::Model
      end
    end
  end
end