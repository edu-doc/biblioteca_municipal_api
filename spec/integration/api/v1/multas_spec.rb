# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/multas', type: :request do
  path '/api/v1/multas' do
    get 'List multas' do
      tags 'Api::V1::Multas'
      produces 'application/json'

      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação'

      response '200', 'multas found' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let!(:multa) { FactoryBot.create(:multum) }
        let(:Authorization) { bibliotecario_logado.token }

        run_test!
      end

      response '401', 'unauthorized' do
        let(:Authorization) { 'invalid_token' }
        run_test!
      end
    end
  end

  path '/api/v1/multas/{id}' do
    get 'Get multa' do
      tags 'Api::V1::Multas'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, required: true

      parameter name: 'Authorization', in: :header, type: :string

      response '200', 'multa found' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { FactoryBot.create(:multum).id }

        run_test!
      end

      response '404', 'multa not found' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { -1 }
        run_test!
      end
    end

    put 'Update multa' do
      tags 'Api::V1::Multas'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, required: true
      parameter name: 'Authorization', in: :header, type: :string
      parameter name: :multa, in: :body, schema: {
        type: :object,
        properties: {
          multa: {
            type: :object,
            properties: {
              status: { type: :string, enum: %w[pago] }
            }
          }
        }
      }

      response '200', 'multa updated' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { FactoryBot.create(:multum, status: :pendente).id }
        let(:multa) { { multa: { status: 'pago' } } }

        run_test!
      end
    end
  end
end
