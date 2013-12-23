class CreateNotifiableDeviceTokens < ActiveRecord::Migration
  
  def change
    create_table :notifiable_device_tokens do |t|
      t.string :token
      t.string :user_id
    	t.string :provider
      t.boolean :is_valid, :default => true

      t.timestamps
    end
  end

end
