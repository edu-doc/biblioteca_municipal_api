# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/usuarios', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/usuarios' do
    post 'Create usuario' do
      tags 'Api::V1::Usuarios'
      consumes 'application/json'
      parameter name: :Authorization, in: :header, type: :string, description: 'Token de autenticação do bibliotecário'
      parameter name: :usuario, in: :body, schema: {
        type: :object,
        properties: {
          usuario: {
            type: :object,
            properties: {
              nome: { type: :string },
              cpf: { type: :string },
              telefone: { type: :string },
              email: { type: :string }
            }
          }
        }
      }

      response '201', 'usuario created' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:usuario) { { usuario: FactoryBot.attributes_for(:usuario) } }
        run_test!
      end


      response '422', 'create usuario error' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:usuario) do
          { usuario: { nome: 'Usuario Teste', cpf: '111.222.33-44', telefone: '55 21-99999-9999',
                       email: 'testegmail.com' } }
        end
        run_test!
      end
    end
  end

  path '/api/v1/usuarios/{id}' do
    #--------------------------------------------- GET -------------------------------------------------

    get 'Get usuario' do
      tags 'Api::V1::Usuarios'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for usuario', required: true

      response '200', 'usuario found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 nome: { type: :string },
                 cpf: { type: :string },
                 telefone: { type: :string },
                 email: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               }

        let(:id) { FactoryBot.create(:usuario).id }

        run_test!
      end

      response '404', 'usuario not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- DELETE -------------------------------------------------

    delete 'Delete usuario' do
      tags 'Api::V1::Usuarios'
      produces 'application/json'
      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação do bibliotecário'
      parameter name: :id, in: :path, type: :string, description: 'id for usuario', required: true

      response '204', 'usuario deleted' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { FactoryBot.create(:usuario).id }
        run_test!
      end

      response '404', 'usuario not found' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- UPDATE -------------------------------------------------

    put 'Update usuario' do
      tags 'Api::V1::Usuarios'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação do bibliotecário'
      parameter name: :id, in: :path, type: :string, description: 'id for usuario', required: true
      parameter name: :usuario, in: :body, schema: {
        type: :object,
        properties: {
          usuario: {
            type: :object,
            properties: {
              nome: { type: :string },
              cpf: { type: :string },
              telefone: { type: :string },
              email: { type: :string }
            }
          }
        }
      }

      response '200', 'usuario updated' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { FactoryBot.create(:usuario).id }
        let(:usuario) do
          { usuario: { nome: 'Usuario Novo', cpf: '910.086.390-44', telefone: '55 21-00000-0000',
                       email: 'novoteste@gmail.com' } }
        end
        run_test!
      end

      response '404', 'usuario not found' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { -1 }
        let(:usuario) do
          { usuario: { nome: 'Usuario Novo', cpf: '910.086.390-44', telefone: '55 21-00000-0000',
                       email: 'novoteste@gmail.com' } }
        end
        run_test!
      end

      response '422', 'update usuario error' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { FactoryBot.create(:usuario).id }
        let(:usuario) do
          { usuario: { nome: '', cpf: '111.222.333-44', telefone: '', email: 'novotestegmail.com' } }
        end
        run_test!
      end
    end
  end

  #--------------------------------------------- Emprestimos do Usuário -------------------------------------------------

  path '/api/v1/usuarios/{id}/emprestimos' do
    get 'Get histórico de empréstimos do usuário' do
      tags 'Api::V1::Usuarios'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for usuario', required: true

      response '200', 'histórico de empréstimos encontrado' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   livro_id: { type: :integer },
                   usuario_id: { type: :integer },
                   bibliotecario_id: { type: :integer },
                   data_emprestimo: { type: :string, format: 'date-time' },
                   data_limite_devolucao: { type: :string, format: 'date-time' },
                   data_devolucao: { type: :string, format: 'date-time', nullable: true }
                 }
               }

        let!(:usuario_existente) { FactoryBot.create(:usuario) }
        before do
          # Cria 3 empréstimos para o usuário
          FactoryBot.create_list(:emprestimo, 3, usuario: usuario_existente)
        end
        let(:id) { usuario_existente.id }

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data.size).to eq(3)
        end
      end

      response '404', 'usuario not found' do
        let(:id) { -1 }
        run_test!
      end
    end
  end
end
