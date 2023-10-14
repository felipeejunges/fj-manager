class CreateClientPlans < ActiveRecord::Migration[7.0]
  def change
    create_table :client_plans do |t|
      t.string :name
      t.string :description
      t.float :price, default: 0.0
      t.boolean :signable, default: true
      t.boolean :sale, default: false
      t.string :code
      t.timestamp :start_date, default: Time.current
      t.timestamp :end_date
      t.integer :billable_period, default: 0
      t.float :max_discount, default: 100.0
      t.boolean :commissionable, default: true
      t.timestamps
    end
  end
end
