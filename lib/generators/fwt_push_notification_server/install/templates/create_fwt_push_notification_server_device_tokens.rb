class CreateFwtPushNotificationServerDeviceTokens < ActiveRecord::Migration
  
  def change
    create_table :fwt_push_notification_server_device_tokens do |t|
      t.string :token
      t.string :user_id
      t.boolean :is_valid, :default => true

      t.timestamps
    end
  end

end
