class CreateNotifiableStatuses < ActiveRecord::Migration
  
  def change
    create_table :notifiable_statuses do |t|
      t.references :notification
      t.references :device_token
      t.integer :status
    end
  end

end
