# frozen_string_literal: true

class AddTitleToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notifications, :title, :string
  end
end
