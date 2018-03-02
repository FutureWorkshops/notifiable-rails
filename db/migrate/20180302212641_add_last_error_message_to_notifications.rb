class AddLastErrorMessageToNotifications < ActiveRecord::Migration
  def change
    add_column :notifiable_notifications, :last_error_message, :text
  end
end
