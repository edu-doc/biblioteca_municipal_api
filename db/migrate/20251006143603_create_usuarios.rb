# frozen_string_literal: true

class CreateUsuarios < ActiveRecord::Migration[8.0]
  def change
    create_table :usuarios do |t|
      t.string :nome, null: false
      t.string :cpf, null: false
      t.string :telefone, null: false
      t.string :email, null: false
      t.string :senha, null: false

      t.timestamps
    end

    add_index :usuarios, :cpf, unique: true
    add_index :usuarios, :email, unique: true
  end
end
