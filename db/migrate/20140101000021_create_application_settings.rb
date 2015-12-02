class CreateApplicationSettings < ActiveRecord::Migration
  def change
    create_table :application_settings do |t|
      t.string :application_name, null: false, default: "Baukis"
      t.integer :expiration_of_session, null: false, default: 60

      t.timestamps
    end
  end
end
