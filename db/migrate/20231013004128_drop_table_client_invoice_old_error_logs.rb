class DropTableClientInvoiceOldErrorLogs < ActiveRecord::Migration[7.0]
  def change
    drop_table :client_invoice_old_error_logs
  end
end
  