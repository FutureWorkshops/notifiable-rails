class AddCategoryToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notification_statuses, :error_message, :string
  end
end
