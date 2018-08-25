# frozen_string_literal: true

class AddCategoryToNotifications < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_notifications, :category, :string
  end
end
