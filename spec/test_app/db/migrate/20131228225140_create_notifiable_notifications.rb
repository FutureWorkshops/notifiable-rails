class CreateNotifiableNotifications < ActiveRecord::Migration
  
  def change
    create_table :notifiable_notifications do |t|
      t.text :message
      t.text :payload
      t.timestamps
    end
  end

end
