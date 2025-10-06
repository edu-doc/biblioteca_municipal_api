# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/livros', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

    path '/api/v1/livros' do

        post 'Create livro' do
        tags 'Api::V1::Livros'
        consumes 'application/json'
        parameter name: :livro, in: :body, schema: {
            type: :object,
            properties: {
            livro: {
                type: :object,
                properties: {
                titulo: { type: :string },
                autor: { type: :string },
                status: { type: :string, enum: ['disponivel', 'emprestado'] },
                observacoes: { type: :string },
                categoria_id: { type: :integer }
                }
            }
            }
        }

        response '201', 'livro created' do
            let(:categoria_existente) { FactoryBot.create(:categoria) }
            let(:livro) do
                attributes = FactoryBot.attributes_for(:livro).merge(categoria_id: categoria_existente.id)
                { livro: attributes }
            end
            run_test!
        end


        response '422', 'create livro error' do
            let(:livro) { { livro: { titulo: "" } } }
            run_test!
        end
        end

        #--------------------------------------------- INDEX -------------------------------------------------

        get 'Get livros' do
        tags 'Api::V1::Livros'
        produces 'application/json'

        response '200', 'livros found' do
            schema type: :array,
                items: {
                    type: :object,
                    properties: {
                    id: { type: :integer },
                    titulo: { type: :string },
                    autor: { type: :string },
                    status: { type: :string, enum: ['disponivel', 'emprestado'] },
                    observacoes: { type: :string },
                    categoria_id: { type: :integer }
                    }
                }

            before do
            FactoryBot.create_list(:livro, 10)
            end
            run_test!
        end
        end

    end

    path '/api/v1/livros/{id}' do
        #--------------------------------------------- SHOW -------------------------------------------------

        get 'Get livro' do
        tags 'Api::V1::Livros'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'id for livro', required: true

        response '200', 'livro found' do
            schema type: :object,
                properties: {
                    id: { type: :integer },
                    titulo: { type: :string },
                    autor: { type: :string },
                    status: { type: :string, enum: ['disponivel', 'emprestado'] },
                    observacoes: { type: :string },
                    categoria_id: { type: :integer }
                }

            let(:id) { FactoryBot.create(:livro).id }

            run_test!
        end

        response '404', 'livro not found' do
            let(:id) { -1 }
            run_test!
        end
        end

        #--------------------------------------------- DELETE -------------------------------------------------

        delete 'Delete livro' do
        tags 'Api::V1::Livros'
        produces 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'id for livro', required: true

        response '204', 'livro deleted' do
            let(:id) { FactoryBot.create(:livro).id }
            run_test!
        end

        response '404', 'livro not found' do
            let(:id) { -1 }
            run_test!
        end
        end

        #--------------------------------------------- UPDATE -------------------------------------------------

        put 'Update livro' do
        tags 'Api::V1::Livros'
        consumes 'application/json'
        parameter name: :id, in: :path, type: :string, description: 'id for livro', required: true
        parameter name: :livro, in: :body, schema: {
            type: :object,
            properties: {
            livro: {
                type: :object,
                properties: {
                titulo: { type: :string },
                autor: { type: :string },
                status: { type: :string, enum: ['disponivel', 'emprestado'] },
                observacoes: { type: :string },
                categoria_id: { type: :integer }
                }
            }
            }
        }

        response '200', 'livro updated' do
            let(:id) { FactoryBot.create(:livro).id }
            let(:livro) do
            { livro: { titulo: 'Novo Titulo' } }
            end
            run_test!
        end

        response '404', 'livro not found' do
            let(:id) { -1 }
            let(:livro) do
            { livro: { titulo: 'Novo Titulo' } }
            end
            run_test!
        end

        response '422', 'update livro error' do
            let(:id) { FactoryBot.create(:livro).id }
            let(:livro) { { livro: { titulo: "" } } }
            run_test!
        end

        end
    end
end
