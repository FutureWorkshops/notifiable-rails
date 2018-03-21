class AddTitleToNotifications < ActiveRecord::Migration
  def change
    add_column :notifiable_notifications, :title, :string
  end
end
