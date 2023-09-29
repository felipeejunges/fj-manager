class CreateClientInvoices < ActiveRecord::Migration[7.0]
  def change
    create_table :client_invoices do |t|
      t.string :description
      t.string :payment_type
      t.integer :reference_month
      t.integer :payment_day
      t.integer :status
      t.timestamp :payed_date
      t.float :invoice_value
      t.boolean :had_error
      t.integer :retries
      t.references :client, null: false, foreign_key: true

      t.timestamps
    end
  end
end
