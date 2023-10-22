class CreateJoinTableRolesPermissions < ActiveRecord::Migration[7.0]
  def change
    create_join_table :roles, :permissions do |t|
      t.index [:role_id, :permission_id], unique: true
      t.index [:permission_id, :role_id], unique: true
    end
  end
end
