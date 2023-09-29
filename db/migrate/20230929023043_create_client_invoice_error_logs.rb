class CreateClientInvoiceErrorLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :client_invoice_error_logs do |t|
      t.references :client_invoice, null: false, foreign_key: true
      t.integer :retry_number
      t.timestamp :date
      t.string :log

      t.timestamps
    end
  end
end
