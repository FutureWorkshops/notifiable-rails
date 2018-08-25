# frozen_string_literal: true

class AddLanguageAndCountryToDeviceTokens < ActiveRecord::Migration[4.2]
  def change
    add_column :notifiable_device_tokens, :language, :string
    add_column :notifiable_device_tokens, :country, :string
  end
end
