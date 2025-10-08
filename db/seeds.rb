# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# NOVO: Cria o primeiro bibliotecário ADMIN, se ele não existir
if Bibliotecario.find_by(email: 'admin@biblioteca.com').nil?
  Bibliotecario.create!(
    email: 'admin@biblioteca.com',
    nome: 'Admin Master',
    senha_provisoria: 'senha123', 
    primeiro_acesso: true,
    role: :admin
  )
  puts 'Admin criado: admin@biblioteca.com com senha provisória: senha123'
end