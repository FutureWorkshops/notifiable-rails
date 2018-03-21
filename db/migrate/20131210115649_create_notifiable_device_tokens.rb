class CreateNotifiableDeviceTokens < ActiveRecord::Migration[4.2]
  
  def change
    create_table :notifiable_device_tokens do |t|
      t.string :token
    	t.string :provider
      t.string :locale
      t.boolean :is_valid, :default => true
      t.string :user_alias
      t.references :app

      t.timestamps
    end

    add_index :notifiable_device_tokens, :user_alias
  end

end
