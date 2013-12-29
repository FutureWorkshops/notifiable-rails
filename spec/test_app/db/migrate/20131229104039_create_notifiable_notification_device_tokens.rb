class CreateNotifiableNotificationDeviceTokens < ActiveRecord::Migration
  
  def change
    create_table :notifiable_notification_device_tokens do |t|
      t.references :notification
      t.references :device_token
      t.timestamps
    end
  end

end
