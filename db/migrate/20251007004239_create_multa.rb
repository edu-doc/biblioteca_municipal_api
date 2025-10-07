# frozen_string_literal: true

class CreateMulta < ActiveRecord::Migration[8.0]
  def change
    create_table :multa do |t|
      t.references :emprestimo, null: false, foreign_key: true, index: { unique: true }
      t.decimal :valor, precision: 10, scale: 2, null: false
      t.integer :status, null: false, default: 0
      t.datetime :data_pagamento
      t.timestamps
    end
  end
end
