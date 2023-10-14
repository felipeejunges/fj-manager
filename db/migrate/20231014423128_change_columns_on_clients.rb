class ChangeColumnsOnClients < ActiveRecord::Migration[7.0]
  def change
    remove_column :clients, :plan_value
    add_column :clients, :discount, :float, default: 0.0
    add_column :clients, :email, :string
    add_column :clients, :client_plan_id, :integer
    add_column :clients, :created_by_id, :integer, null: true

    add_foreign_key :clients, :client_plans, column: :client_plan_id
    add_foreign_key :clients, :users, column: :created_by_id
  end
end
  