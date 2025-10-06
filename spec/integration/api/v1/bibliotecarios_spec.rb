# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/bibliotecarios', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/bibliotecarios' do
    post 'Create bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      consumes 'application/json'
      parameter name: :bibliotecario, in: :body, schema: {
        type: :object,
        properties: {
          bibliotecario: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              nome: { type: :string }
            }
          }
        }
      }

      response '201', 'bibliotecario created' do
        let(:bibliotecario) { { bibliotecario: FactoryBot.attributes_for(:bibliotecario) } }
        run_test!
      end


      response '422', 'create bibliotecario error' do
        let(:bibliotecario) { { bibliotecario: { email: 'invalidgmail.com', password: '123', nome: 'Errito' } } }
        run_test!
      end
    end
  end

  path '/api/v1/bibliotecarios/{id}' do
    #--------------------------------------------- GET -------------------------------------------------

    get 'Get bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for bibliotecario', required: true

      response '200', 'bibliotecario found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 nome: { type: :string },
                 email: { type: :string },
                 senha_provisoria: { type: :string },
                 created_at: { type: :string, format: 'date-time' },
                 updated_at: { type: :string, format: 'date-time' }
               }

        let(:id) { FactoryBot.create(:bibliotecario).id }

        run_test!
      end

      response '404', 'bibliotecario not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- DELETE -------------------------------------------------

    delete 'Delete bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for bibliotecario', required: true

      response '204', 'bibliotecario deleted' do
        let(:id) { FactoryBot.create(:bibliotecario).id }
        run_test!
      end

      response '404', 'bibliotecario not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- UPDATE -------------------------------------------------

    put 'Update bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for bibliotecario', required: true
      parameter name: :bibliotecario, in: :body, schema: {
        type: :object,
        properties: {
          bibliotecario: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string },
              nome: { type: :string }
            }
          }
        }
      }

      response '200', 'bibliotecario updated' do
        let(:id) { FactoryBot.create(:bibliotecario).id }
        let(:bibliotecario) do
          { bibliotecario: { email: 'novoemail@gmail.com', password: 'novo password', nome: 'Novo Nome' } }
        end
        run_test!
      end

      response '404', 'bibliotecario not found' do
        let(:id) { -1 }
        let(:bibliotecario) do
          { bibliotecario: { email: 'novoemail@gmail.com', password: 'novo password', nome: 'Novo Nome' } }
        end
        run_test!
      end

      response '422', 'update bibliotecario error' do
        let(:id) { FactoryBot.create(:bibliotecario).id }
        let(:bibliotecario) { { bibliotecario: { email: 'invalidgmail.com', password: '123', nome: 'Errito' } } }
        run_test!
      end
      
    end
  end
end
