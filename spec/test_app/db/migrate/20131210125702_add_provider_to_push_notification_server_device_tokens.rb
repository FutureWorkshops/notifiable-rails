class AddProviderToPushNotificationServerDeviceTokens < ActiveRecord::Migration
  
  def change
  	add_column :fwt_push_notification_server_device_tokens, :provider, :string
  end

end
