class RemoveIsValidFromNotifiableDeviceTokens < ActiveRecord::Migration[4.2]
  
  def change
    remove_column :notifiable_device_tokens, :is_valid, :boolean, default: true
  end

end
