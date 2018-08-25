# frozen_string_literal: true

class CreateNotifiableStatuses < ActiveRecord::Migration[4.2]
  def change
    create_table :notifiable_statuses do |t|
      t.references :notification
      t.references :device_token
      t.integer :status
      t.datetime :created_at
    end
  end
end
