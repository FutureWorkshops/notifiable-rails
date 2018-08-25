# frozen_string_literal: true

class CreateNotifiableApps < ActiveRecord::Migration[4.2]
  def change
    create_table :notifiable_apps do |t|
      t.string :name
      t.text :configuration

      t.timestamps
    end
  end
end
