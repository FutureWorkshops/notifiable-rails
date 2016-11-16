class CreateNotifiableNotifications < ActiveRecord::Migration
  
  def change
    create_table :notifiable_notifications do |t|
      t.references :app
      
      #stats
      t.integer :sent_count, :default => 0
      t.integer :gateway_accepted_count, :default => 0
      t.integer :opened_count, :default => 0
      
      # notification properties
      t.text :message
      t.text :parameters
      t.string :sound
      
      # apns
      t.string :identifier
      t.datetime :expiry
      t.boolean :content_available
      t.boolean :mutable_content
      
      t.timestamps
    end
  end

end
