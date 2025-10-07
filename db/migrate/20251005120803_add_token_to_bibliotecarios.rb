# frozen_string_literal: true

class AddTokenToBibliotecarios < ActiveRecord::Migration[8.0]
  def change
    add_column :bibliotecarios, :token, :string
    add_index :bibliotecarios, :token, unique: true
  end
end
