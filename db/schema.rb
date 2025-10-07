# frozen_string_literal: true

# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 20_251_007_004_239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'pg_catalog.plpgsql'

  create_table 'bibliotecarios', force: :cascade do |t|
    t.string 'email', default: '', null: false
    t.string 'encrypted_password', default: '', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.string 'nome', null: false
    t.string 'senha_provisoria'
    t.boolean 'primeiro_acesso', default: true, null: false
    t.string 'token', default: 'xxxxxxxx', null: false
    t.index ['email'], name: 'index_bibliotecarios_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_bibliotecarios_on_reset_password_token', unique: true
    t.index ['token'], name: 'index_bibliotecarios_on_token', unique: true
  end

  create_table 'categoria', force: :cascade do |t|
    t.string 'nome', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['nome'], name: 'index_categoria_on_nome', unique: true
  end

  create_table 'emprestimos', force: :cascade do |t|
    t.bigint 'livro_id', null: false
    t.bigint 'usuario_id', null: false
    t.bigint 'bibliotecario_id', null: false
    t.datetime 'data_emprestimo', null: false
    t.datetime 'data_limite_devolucao', null: false
    t.datetime 'data_devolucao'
    t.integer 'contador_renovacao', default: 0, null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['bibliotecario_id'], name: 'index_emprestimos_on_bibliotecario_id'
    t.index ['livro_id'], name: 'index_emprestimos_on_livro_id'
    t.index ['usuario_id'], name: 'index_emprestimos_on_usuario_id'
  end

  create_table 'livros', force: :cascade do |t|
    t.string 'titulo', null: false
    t.string 'autor', null: false
    t.integer 'status', default: 0, null: false
    t.text 'observacoes'
    t.bigint 'categoria_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['categoria_id'], name: 'index_livros_on_categoria_id'
  end

  create_table 'multa', force: :cascade do |t|
    t.bigint 'emprestimo_id', null: false
    t.decimal 'valor', precision: 10, scale: 2, null: false
    t.integer 'status', default: 0, null: false
    t.datetime 'data_pagamento'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['emprestimo_id'], name: 'index_multa_on_emprestimo_id', unique: true
  end

  create_table 'usuarios', force: :cascade do |t|
    t.string 'nome', null: false
    t.string 'cpf', null: false
    t.string 'telefone', null: false
    t.string 'email', null: false
    t.string 'senha', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['cpf'], name: 'index_usuarios_on_cpf', unique: true
    t.index ['email'], name: 'index_usuarios_on_email', unique: true
  end

  add_foreign_key 'emprestimos', 'bibliotecarios'
  add_foreign_key 'emprestimos', 'livros'
  add_foreign_key 'emprestimos', 'usuarios'
  add_foreign_key 'livros', 'categoria', column: 'categoria_id'
  add_foreign_key 'multa', 'emprestimos'
end
