# frozen_string_literal: true

class AddNameToNotifiableDeviceTokens < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_device_tokens, :name, :string
  end
end
