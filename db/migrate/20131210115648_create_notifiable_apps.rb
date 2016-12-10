class CreateNotifiableApps < ActiveRecord::Migration[5.0]
  def change
    create_table :notifiable_apps do |t|
      t.string :name
      t.text :configuration

      t.timestamps
    end
  end
end
