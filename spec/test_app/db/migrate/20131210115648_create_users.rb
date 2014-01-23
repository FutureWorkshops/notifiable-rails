class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.string :email,              :null => false, :default => ""
      t.string :locale
    end
  end
end