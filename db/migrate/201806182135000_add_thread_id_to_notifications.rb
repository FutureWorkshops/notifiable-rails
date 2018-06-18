class AddThreadIdToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notifications, :thead_id, :string
  end
end
