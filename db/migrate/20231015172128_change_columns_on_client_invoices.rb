class ChangeColumnsOnClientInvoices < ActiveRecord::Migration[7.0]
  def change
    add_column :client_invoices, :client_plan_id, :integer

    add_foreign_key :client_invoices, :client_plans, column: :client_plan_id
  end
end
  