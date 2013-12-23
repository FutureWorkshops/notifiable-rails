class AddProviderToPushNotificationServerDeviceTokens < ActiveRecord::Migration
  
  def change
  	add_column :notifiable_device_tokens, :provider, :string
  end

end
