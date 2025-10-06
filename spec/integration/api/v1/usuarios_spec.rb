# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/usuarios', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/usuarios' do
    post 'Create usuario' do
      tags 'Api::V1::Usuarios'
      consumes 'application/json'
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
        let(:usuario) { { usuario: FactoryBot.attributes_for(:usuario) } }
        run_test!
      end


      response '422', 'create usuario error' do
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
      parameter name: :id, in: :path, type: :string, description: 'id for usuario', required: true

      response '204', 'usuario deleted' do
        let(:id) { FactoryBot.create(:usuario).id }
        run_test!
      end

      response '404', 'usuario not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- UPDATE -------------------------------------------------

    put 'Update usuario' do
      tags 'Api::V1::Usuarios'
      consumes 'application/json'
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
        let(:id) { FactoryBot.create(:usuario).id }
        let(:usuario) do
          { usuario: { nome: 'Usuario Novo', cpf: '910.086.390-44', telefone: '55 21-00000-0000',
                       email: 'novoteste@gmail.com' } }
        end
        run_test!
      end

      response '404', 'usuario not found' do
        let(:id) { -1 }
        let(:usuario) do
          { usuario: { nome: 'Usuario Novo', cpf: '910.086.390-44', telefone: '55 21-00000-0000',
                       email: 'novoteste@gmail.com' } }
        end
        run_test!
      end

      response '422', 'update usuario error' do
        let(:id) { FactoryBot.create(:usuario).id }
        let(:usuario) do
          { usuario: { nome: '', cpf: '111.222.333-44', telefone: '', email: 'novotestegmail.com' } }
        end
        run_test!
      end
    end
  end
end
