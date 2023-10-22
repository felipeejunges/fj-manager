class CreatePermissions < ActiveRecord::Migration[7.0]
  def change
    create_table :permissions do |t|
      t.string :key
      t.string :action
      t.string :description

      t.timestamps
    end
  end
end
