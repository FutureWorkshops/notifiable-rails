class AddLastErrorMessageToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notifications, :last_error_message, :text
  end
end
