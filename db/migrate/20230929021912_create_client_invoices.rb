class CreateClientInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :client_invoices do |t|
      t.string :description
      t.string :payment_type
      t.date :reference_date
      t.integer :status
      t.timestamp :payed_date
      t.float :invoice_value
      t.integer :max_retries, default: 10
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
