class CreateRoles < ActiveRecord::Migration[7.0]
  def change
    create_table :roles do |t|
      t.string :name
      t.string :description
      t.string :code
      t.boolean :active, default: true
      t.boolean :deleteable, default: false
      t.boolean :editable, default: false

      t.timestamps
    end
  end
end
