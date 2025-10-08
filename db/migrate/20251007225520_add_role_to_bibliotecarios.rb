class AddRoleToBibliotecarios < ActiveRecord::Migration[8.0]
  def change
    add_column :bibliotecarios, :role, :integer, default: 0, null: false
  end
end
