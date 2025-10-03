# frozen_string_literal: true

class AddFieldsToBibliotecarios < ActiveRecord::Migration[8.0]
  def change
    add_column :bibliotecarios, :nome, :string
    add_column :bibliotecarios, :senha_provisoria, :string
    add_column :bibliotecarios, :primeiro_acesso, :boolean, default: true
  end
end
