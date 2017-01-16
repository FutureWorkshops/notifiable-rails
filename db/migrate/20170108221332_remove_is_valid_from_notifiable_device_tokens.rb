class RemoveIsValidFromNotifiableDeviceTokens < ActiveRecord::Migration
  
  def change
    remove_column :notifiable_device_tokens, :is_valid, :boolean, default: true
  end

end
