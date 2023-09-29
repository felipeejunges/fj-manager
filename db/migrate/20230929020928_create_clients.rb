class CreateClients < ActiveRecord::Migration[7.0]
  def change
    create_table :clients do |t|
      t.string :name
      t.string :document
      t.integer :document_type
      t.string :payment_type
      t.integer :payment_day
      t.float :plan_value

      t.timestamps
    end
  end
end
