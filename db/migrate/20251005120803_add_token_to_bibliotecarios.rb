class AddTokenToBibliotecarios < ActiveRecord::Migration[8.0]
  def change
    add_column :bibliotecarios, :token, :string, default: "xxxxxxxx", null: false
    add_index :bibliotecarios, :token, unique: true
  end
end
