class SorceryCore < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :crypted_password, :string
    add_column :users, :salt, :string

    remove_column :users, :password_digest
    remove_column :users, :admin
  end
end
