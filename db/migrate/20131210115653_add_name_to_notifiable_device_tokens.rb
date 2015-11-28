class AddNameToNotifiableDeviceTokens < ActiveRecord::Migration
  
  def change
    add_column :notifiable_device_tokens, :name, :string
  end

end
