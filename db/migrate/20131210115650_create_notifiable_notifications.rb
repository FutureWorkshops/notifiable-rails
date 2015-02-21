class CreateNotifiableNotifications < ActiveRecord::Migration
  
  def change
    create_table :notifiable_notifications do |t|
      t.text :message
      t.text :params
      t.references :app
      
      #stats
      t.integer :sent_count, :default => 0
      t.integer :gateway_accepted_count, :default => 0
      t.integer :opened_count, :default => 0
      
      # APNS - Optional
      #t.integer :badge
      #t.text :sound
      #t.datetime :expiry
      
      # MPNS - Optional
      #t.text :title
      
      t.timestamps
    end
  end

end
