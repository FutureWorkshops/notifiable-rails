class CreateNotifiableStatuses < ActiveRecord::Migration
  
  def change
    create_table :notifiable_statuses do |t|
      t.references :localized_notification
      t.references :device_token
      t.integer :status
      t.datetime :created_at
    end    
  end

end
