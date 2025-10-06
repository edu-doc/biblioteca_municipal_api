# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/emprestimos', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/emprestimos' do
    post 'Create emprestimo' do
      tags 'Api::V1::Emprestimos'
      consumes 'application/json'
      parameter name: :emprestimo, in: :body, schema: {
        type: :object,
        properties: {
          emprestimo: {
            type: :object,
            properties: {
              livro_id: { type: :integer },
              usuario_id: { type: :integer },
              bibliotecario_id: { type: :integer },
              data_emprestimo: { type: :string, format: 'date-time' },
              data_limite_devolucao: { type: :string, format: 'date-time' },
              data_devolucao: { type: :string, format: 'date-time', nullable: true }
            }
          }
        }
      }

      response '201', 'emprestimo created' do
        let(:livro_existente) { FactoryBot.create(:livro) }
        let(:usuario_existente) { FactoryBot.create(:usuario) }
        let(:bibliotecario_existente) { FactoryBot.create(:bibliotecario) }
        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: livro_existente.id,
              usuario_id: usuario_existente.id,
              bibliotecario_id: bibliotecario_existente.id,
              data_emprestimo: Time.now, # ✅ ADICIONE ESTA LINHA
              data_limite_devolucao: 7.days.from_now
            }
          }
        end
        run_test!
      end


      response '422', 'create emprestimo error' do
        let(:emprestimo) { { emprestimo: { livro_id: '' } } }
        run_test!
      end
    end

    #--------------------------------------------- INDEX -------------------------------------------------

    get 'Get emprestimos' do
      tags 'Api::V1::Emprestimos'
      produces 'application/json'

      response '200', 'emprestimos found' do
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

        before do
          FactoryBot.create_list(:emprestimo, 10)
        end
        run_test!
      end
    end
  end

  path '/api/v1/emprestimos/{id}' do
    #--------------------------------------------- SHOW -------------------------------------------------

    get 'Get emprestimo' do
      tags 'Api::V1::Emprestimos'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for emprestimo', required: true

      response '200', 'emprestimo found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 livro_id: { type: :integer },
                 usuario_id: { type: :integer },
                 bibliotecario_id: { type: :integer },
                 data_emprestimo: { type: :string, format: 'date-time' },
                 data_limite_devolucao: { type: :string, format: 'date-time' },
                 data_devolucao: { type: :string, format: 'date-time', nullable: true }
               }

        let(:id) { FactoryBot.create(:emprestimo).id }

        run_test!
      end

      response '404', 'emprestimo not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- DELETE -------------------------------------------------

    delete 'Delete emprestimo' do
      tags 'Api::V1::Emprestimos'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for emprestimo', required: true

      response '204', 'emprestimo deleted' do
        let(:id) { FactoryBot.create(:emprestimo).id }
        run_test!
      end

      response '404', 'emprestimo not found' do
        let(:id) { -1 }
        run_test!
      end
    end

    #--------------------------------------------- UPDATE -------------------------------------------------

    put 'Update emprestimo' do
      tags 'Api::V1::Emprestimos'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for emprestimo', required: true
      parameter name: :emprestimo, in: :body, schema: {
        type: :object,
        properties: {
          emprestimo: {
            type: :object,
            properties: {
              livro_id: { type: :integer },
              usuario_id: { type: :integer },
              bibliotecario_id: { type: :integer },
              data_emprestimo: { type: :string, format: 'date-time' },
              data_limite_devolucao: { type: :string, format: 'date-time' },
              data_devolucao: { type: :string, format: 'date-time', nullable: true }
            }
          }
        }
      }

      response '200', 'emprestimo updated' do
        let!(:emprestimo_existente) { FactoryBot.create(:emprestimo) }
        let!(:novo_livro) { FactoryBot.create(:livro) }

        let(:id) { emprestimo_existente.id }

        let(:emprestimo) do
          { emprestimo: { livro_id: novo_livro.id } }
        end
        run_test!
      end

      response '404', 'emprestimo not found' do
        let(:id) { -1 }
        let(:emprestimo) do
          { emprestimo: { livro_id: 1 } }
        end
        run_test!
      end

      response '422', 'update emprestimo error' do
        let(:id) { FactoryBot.create(:emprestimo).id }
        let(:emprestimo) { { emprestimo: { livro_id: -1 } } }
        run_test!
      end
    end
  end
end
