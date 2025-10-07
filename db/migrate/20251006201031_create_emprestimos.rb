# frozen_string_literal: true

class CreateEmprestimos < ActiveRecord::Migration[8.0]
  def change
    create_table :emprestimos do |t|
      t.references :livro, null: false, foreign_key: true
      t.references :usuario, null: false, foreign_key: true
      t.references :bibliotecario, null: false, foreign_key: true
      t.datetime :data_emprestimo, null: false
      t.datetime :data_limite_devolucao, null: false
      t.datetime :data_devolucao
      t.integer :contador_renovacao, null: false, default: 0

      t.timestamps
    end
  end
end
