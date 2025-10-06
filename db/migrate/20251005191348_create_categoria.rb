# frozen_string_literal: true

class CreateCategoria < ActiveRecord::Migration[8.0]
  def change
    create_table :categoria do |t|
      t.string :nome, null: false

      t.timestamps
    end
    add_index :categoria, :nome, unique: true
  end
end
