class AddSocialToUsers < ActiveRecord::Migration
  def change
    add_column :users, :provider, :string
    add_column :users, :hid, :string
  end
end
