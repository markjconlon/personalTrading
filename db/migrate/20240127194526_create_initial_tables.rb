# frozen_string_literal: true

class CreateInitialTables < ActiveRecord::Migration[7.1]
  def change
    create_table :accounts do |t|
      t.string :name, index: true, null: false
      t.references :owner, index: true, null: false
      t.timestamps
    end

    create_table :owners do |t|
      t.string :firstname, null: false
      t.string :lastname, null: false
      t.timestamps
    end

    create_table :trades do |t|
      t.string :type, index: true, null: false
      t.integer :shares, null: false
      t.integer :price, null: false
      t.datetime :datetime, null: false, index: true
      t.references :account, index: true
      t.references :stock, index: true
      t.timestamps
    end

    create_table :dividends do |t|
      t.integer :amount, null: false
      t.datetime :datetime, null: false, index: true
      t.string :currency, null: false, index: true
      t.references :account, index: true
      t.references :stock, index: true
      t.timestamps
    end

    create_table :stocks do |t|
      t.string :ticker, null: false, index: { unique: true }
      t.string :currency, null: false, index: true
    end

    create_table :transactions do |t|
      t.integer :amount, null: false
      t.datetime :datetime, null: false, index: true
      t.string :type, null: false, index: true
      t.string :currency, null: false, index: true
      t.references :account, index: true, null: false
      t.timestamps
    end
  end
end
