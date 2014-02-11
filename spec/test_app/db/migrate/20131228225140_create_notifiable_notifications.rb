class CreateNotifiableNotifications < ActiveRecord::Migration
  
  def change
    create_table :notifiable_notifications do |t|
      t.text :title
      t.text :message
      t.text :params
      t.integer :badge
      t.text :sound
      t.datetime :expiry
      t.timestamps
    end
  end

end
