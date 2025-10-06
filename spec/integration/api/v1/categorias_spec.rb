# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/categorias', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/categorias' do
    post 'Create categoria' do
      tags 'Api::V1::Categorias'
      consumes 'application/json'
      parameter name: :categoria, in: :body, schema: {
        type: :object,
        properties: {
          categoria: {
            type: :object,
            properties: {
              nome: { type: :string }
            }
          }
        }
      }

      response '201', 'categoria created' do
        let(:categoria) { { categoria: FactoryBot.attributes_for(:categoria) } }
        run_test!
      end


      response '422', 'create categoria error' do
        let(:categoria) { { categoria: { nome: '' } } }
        run_test!
      end
    end

    #--------------------------------------------- INDEX -------------------------------------------------

    get 'Get categorias' do
      tags 'Api::V1::Categorias'
      produces 'application/json'

      response '200', 'categorias found' do
        schema type: :array,
               items: {
                 type: :object,
                 properties: {
                   id: { type: :integer },
                   nome: { type: :string },
                   created_at: { type: :string, format: 'date-time' },
                   updated_at: { type: :string, format: 'date-time' }
                 }
               }

        before do
          FactoryBot.create_list(:categoria, 10)
        end
        run_test!
      end
    end
  end

  path '/api/v1/categorias/{id}' do
    #--------------------------------------------- SHOW -------------------------------------------------

    get 'Get categoria' do
      tags 'Api::V1::Categorias'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for categoria', required: true

      response '200', 'categoria found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 nome: { type: :string }
               }

        let(:id) { FactoryBot.create(:categoria).id }

        run_test!
      end

      response '404', 'categoria not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- DELETE -------------------------------------------------

    delete 'Delete categoria' do
      tags 'Api::V1::Categorias'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for categoria', required: true

      response '204', 'categoria deleted' do
        let(:id) { FactoryBot.create(:categoria).id }
        run_test!
      end

      response '404', 'categoria not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- UPDATE -------------------------------------------------

    put 'Update categoria' do
      tags 'Api::V1::Categorias'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for categoria', required: true
      parameter name: :categoria, in: :body, schema: {
        type: :object,
        properties: {
          categoria: {
            type: :object,
            properties: {
              nome: { type: :string }
            }
          }
        }
      }

      response '200', 'categoria updated' do
        let(:id) { FactoryBot.create(:categoria).id }
        let(:categoria) do
          { categoria: { nome: 'Novo Nome' } }
        end
        run_test!
      end

      response '404', 'categoria not found' do
        let(:id) { -1 }
        let(:categoria) do
          { categoria: { nome: 'Novo Nome' } }
        end
        run_test!
      end

      response '422', 'update categoria error' do
        let(:id) { FactoryBot.create(:categoria).id }
        let(:categoria) { { categoria: { nome: '' } } }
        run_test!
      end
    end
  end
end
