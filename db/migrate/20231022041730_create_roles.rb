class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
