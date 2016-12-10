class AddNameToNotifiableDeviceTokens < ActiveRecord::Migration[5.0]
  
  def change
    add_column :notifiable_device_tokens, :name, :string
  end

end
