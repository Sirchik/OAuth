class AddOmniauthToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :provider1, :string
    add_column :users, :uid1, :string
  end
end
