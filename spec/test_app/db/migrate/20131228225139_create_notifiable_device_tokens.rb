class CreateNotifiableDeviceTokens < ActiveRecord::Migration
  
  def change
    create_table :notifiable_device_tokens do |t|
      t.string :token
    	t.string :provider
      t.string :device_id
      t.boolean :is_valid, :default => true
      t.integer :user_id
      t.references :app

      t.timestamps
    end

    add_index :notifiable_device_tokens, :device_id, :unique => true  
    add_index :notifiable_device_tokens, :token, :unique => true      
    add_index :notifiable_device_tokens, :user_id
  end

end
