require 'rails/generators/migration'

module FwtPushNotificationServer
  module Generators
  
    class InstallGenerator < ::Rails::Generators::Base
      
      include Rails::Generators::Migration
      
      source_root File.expand_path('../templates', __FILE__)

      desc "Add the migrations"

      def self.next_migration_number(path)
        unless @prev_migration_nr
          @prev_migration_nr = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        else
          @prev_migration_nr += 1
        end
        @prev_migration_nr.to_s
      end

      def copy_migrations
        migration_template "create_fwt_push_notification_server_device_tokens.rb", "db/migrate/create_fwt_push_notification_server_device_tokens.rb"
      end

      desc "Add initializer"

      def copy_initializer_file
        copy_file "initializer.rb", "config/initializers/#{app_name}.rb"
      end
    
      private
        def app_name
          "fwt_push_notification_server"
        end

    end

  end
end