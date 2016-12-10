class CreateNotifiableStatuses < ActiveRecord::Migration[5.0]
  
  def change
    create_table :notifiable_statuses do |t|
      t.references :notification
      t.references :device_token
      t.integer :status
      t.datetime :created_at
    end    
  end

end
