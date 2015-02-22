class CreateNotifiableNotifications < ActiveRecord::Migration
  
  def change
    create_table :notifiable_notifications do |t|
      t.references :app
      
      #stats
      t.integer :sent_count, :default => 0
      t.integer :gateway_accepted_count, :default => 0
      t.integer :opened_count, :default => 0
      
      t.timestamps
    end
  end

end
