class ChangeColumnsOnClients < ActiveRecord::Migration[7.0]
  def change
    remove_column :clients, :plan_value
    add_column :clients, :discount, :float, default: 0.0
    add_column :clients, :client_plan_id, :integer
    add_foreign_key :clients, :client_plans, column: :client_plan_id
  end
end
  