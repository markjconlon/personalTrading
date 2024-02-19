class CreateConversionTable < ActiveRecord::Migration[7.1]
  def change
    create_table :conversions do |t|
      t.integer :amount_in, null: false
      t.integer :amount_out, null: false
      t.datetime :datetime, null: false, index: true
      t.string :currency_in, null: false, index: true
      t.string :currency_out, null: false, index: true
      t.references :account, index: :true, null: false
      t.timestamps
    end
  end
end
