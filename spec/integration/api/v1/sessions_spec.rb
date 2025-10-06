# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/sessions', type: :request do
  #--------------------------------------------- POST (Login) -------------------------------------------------

  path '/api/v1/sessions' do
    post 'Login' do
      tags 'Api::V1::Sessions'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          session: {
            type: :object,
            properties: {
              email: { type: :string },
              password: { type: :string }
            },
            required: %w[email password]
          }
        }
      }

      response '200', 'Successful Login' do
        schema type: :object,
               properties: {
                 token: { type: :string },
                 primeiro_acesso: { type: :boolean }
               }

        let(:bibliotecario) { FactoryBot.create(:bibliotecario) }
        let(:session) do
          {
            session: {
              email: bibliotecario.email,
              password: bibliotecario.password
            }
          }
        end
        run_test!
      end

      response '401', 'Invalid credentials' do
        let(:bibliotecario) { FactoryBot.create(:bibliotecario) }
        let(:session) do
          {
            session: {
              email: bibliotecario.email,
              password: ''
            }
          }
        end

        run_test!
      end
    end
  end

  #--------------------------------------------- DELETE (Logout) -------------------------------------------------

  path '/api/v1/sessions' do
    delete 'Logout' do
      tags 'Api::V1::Sessions'
      consumes 'application/json'
      parameter name: :session, in: :body, schema: {
        type: :object,
        properties: {
          token: { type: :string }
        },
        required: ['token']
      }

      response '204', 'Successful Logout' do
        let(:bibliotecario) { FactoryBot.create(:bibliotecario) }
        before do
          bibliotecario.gerador_token_autenticacao
          bibliotecario.save
        end
        let(:session) { { token: bibliotecario.token } }

        run_test!
      end

      response '404', 'Token not found' do
        let(:session) { { token: '' } }
        run_test!
      end
    end
  end
end
