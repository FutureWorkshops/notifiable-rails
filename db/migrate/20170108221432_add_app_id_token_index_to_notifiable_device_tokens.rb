class AddAppIdTokenIndexToNotifiableDeviceTokens < ActiveRecord::Migration[4.2]
  
  def change
    add_index :notifiable_device_tokens, [:app_id, :token], unique: true
  end

end
