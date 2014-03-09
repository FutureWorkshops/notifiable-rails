class CreateNotifiableApps < ActiveRecord::Migration
  def change
    create_table :notifiable_apps do |t|
      t.string :name
      t.text :configuration

      t.timestamps
    end
  end
end
