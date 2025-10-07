# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/emprestimos', type: :request do
  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/emprestimos' do
    post 'Create emprestimo' do
      tags 'Api::V1::Emprestimos'
      consumes 'application/json'

      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação do bibliotecário'

      parameter name: :emprestimo, in: :body, schema: {
        type: :object,
        properties: {
          emprestimo: {
            type: :object,
            properties: {
              livro_id: { type: :integer },
              usuario_id: { type: :integer },
              senha: { type: :string }
            },
            required: %w[livro_id usuario_id senha]
          }
        }
      }

      response '201', 'emprestimo created' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let!(:livro_existente) { FactoryBot.create(:livro, status: :disponivel) }
        let!(:usuario_existente) { FactoryBot.create(:usuario) }

        let(:Authorization) { bibliotecario_logado.token }

        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: livro_existente.id,
              usuario_id: usuario_existente.id,
              senha: usuario_existente.senha
            }
          }
        end

        run_test!
      end

      response '404', 'not found' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let!(:usuario_existente) { FactoryBot.create(:usuario) }

        let(:Authorization) { bibliotecario_logado.token }

        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: -1,
              usuario_id: usuario_existente.id,
              senha: usuario_existente.senha
            }
          }
        end
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

  #---------------------------------------------- Renovação -------------------------------------------------

  path '/api/v1/emprestimos/renovar' do
    post 'Renovação Online (Usuário)' do
      tags 'Api::V1::Emprestimos'
      consumes 'application/json'

      parameter name: :emprestimo, in: :body, schema: {
        type: :object,
        properties: {
          emprestimo: {
            type: :object,
            properties: {
              livro_id: { type: :integer, description: 'ID do livro a ser renovado' },
              senha: { type: :string, description: 'Senha de empréstimo do usuário' }
            },
            required: %w[livro_id senha]
          }
        }
      }

      response '200', 'renovação registrada com sucesso' do
        let!(:usuario) { FactoryBot.create(:usuario) }
        let!(:livro) { FactoryBot.create(:livro, status: :emprestado) }
        let!(:emprestimo_ativo) do
          FactoryBot.create(:emprestimo, usuario: usuario, livro: livro, contador_renovacao: 0, data_devolucao: nil)
        end

        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: livro.id,
              senha: usuario.senha
            }
          }
        end

        run_test! do |response|
          data = JSON.parse(response.body, symbolize_names: true)
          expect(data[:contador_renovacao]).to eq(1)
        end
      end

      response '401', 'Senha de empréstimo inválida' do
        let!(:usuario) { FactoryBot.create(:usuario) }
        let!(:livro) { FactoryBot.create(:livro, status: :emprestado) }
        let!(:emprestimo_ativo) do
          FactoryBot.create(:emprestimo, usuario: usuario, livro: livro, contador_renovacao: 0, data_devolucao: nil)
        end

        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: livro.id,
              senha: 'senha-invalida'
            }
          }
        end

        run_test!
      end

      response '404', 'Empréstimo ativo para este livro não encontrado' do
        let!(:usuario) { FactoryBot.create(:usuario) }

        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: -1,
              senha: usuario.senha
            }
          }
        end
        run_test!
      end

      response '422', 'Limite de renovação atingido' do
        let!(:usuario) { FactoryBot.create(:usuario) }
        let!(:livro) { FactoryBot.create(:livro, status: :emprestado) }
        let!(:emprestimo_max_renovacoes) do
          FactoryBot.create(:emprestimo, usuario: usuario, livro: livro, contador_renovacao: ::Emprestimo::MAX_RENOVATIONS,
                                         data_devolucao: nil)
        end

        let(:emprestimo) do
          {
            emprestimo: {
              livro_id: livro.id,
              senha: usuario.senha
            }
          }
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

    put 'Registrar Devolução de um Empréstimo' do
      tags 'Api::V1::Emprestimos'
      consumes 'application/json'
      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação do bibliotecário'
      parameter name: :id, in: :path, type: :string, description: 'ID do empréstimo a ser devolvido', required: true

      # Esta ação não precisa de um corpo (body), então não precisamos do 'parameter name: :emprestimo'

      response '200', 'devolução registrada com sucesso' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let!(:emprestimo_existente) { FactoryBot.create(:emprestimo, bibliotecario: bibliotecario_logado) }

        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { emprestimo_existente.id }

        # Não é necessário enviar um corpo na requisição 'let(:emprestimo)'

        run_test!
      end

      response '404', 'empréstimo não encontrado' do
        let!(:bibliotecario_logado) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { bibliotecario_logado.token }
        let(:id) { -1 }

        run_test!
      end
    end
  end
end
