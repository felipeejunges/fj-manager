class RenameTableFromClientInvoiceErrorLogsToClientInvoiceOldErrorLogs < ActiveRecord::Migration[7.0]
  def change
    rename_table :client_invoice_error_logs, :client_invoice_old_error_logs
  end
end
  