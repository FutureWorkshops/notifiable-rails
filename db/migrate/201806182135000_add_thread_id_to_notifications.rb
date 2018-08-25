# frozen_string_literal: true

class AddThreadIdToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notifications, :thread_id, :string
  end
end
