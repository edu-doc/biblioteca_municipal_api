# frozen_string_literal: true

class AddFieldsToBibliotecarios < ActiveRecord::Migration[8.0]
  def change
    add_column :bibliotecarios, :nome, :string, null: false
    add_column :bibliotecarios, :senha_provisoria, :string, null: false
    add_column :bibliotecarios, :primeiro_acesso, :boolean, default: true, null: false
  end
end