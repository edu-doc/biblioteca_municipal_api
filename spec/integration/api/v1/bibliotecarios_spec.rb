# frozen_string_literal: true

require 'swagger_helper'

RSpec.describe 'api/v1/bibliotecarios', type: :request do

  # --- Configuração Global de Tokens ---
  # Cria o admin com primeiro_acesso: false para evitar o bloqueio de troca de senha
  let!(:admin_bibliotecario) { FactoryBot.create :bibliotecario, role: :admin, primeiro_acesso: false }
  let(:admin_token) { admin_bibliotecario.token }
  
  # Cria o owner com primeiro_acesso: false para visualização e self-update
  let!(:bibliotecario_owner) { FactoryBot.create :bibliotecario, primeiro_acesso: false }
  let(:owner_token) { bibliotecario_owner.token }

  #--------------------------------------------- POST -------------------------------------------------

  path '/api/v1/bibliotecarios' do
    post 'Create bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      consumes 'application/json'
      
      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação do administrador'
      
      parameter name: :bibliotecario, in: :body, schema: {
        type: :object,
        properties: {
          bibliotecario: {
            type: :object,
            properties: {
              email: { type: :string },
              senha_provisoria: { type: :string },
              nome: { type: :string }
            }
          }
        }
      }

      response '201', 'bibliotecario created' do
        let(:Authorization) { admin_token }
        let(:bibliotecario) { { bibliotecario: FactoryBot.attributes_for(:bibliotecario) } }
        run_test!
      end


      response '422', 'create bibliotecario error' do
        let(:Authorization) { admin_token }
        let(:bibliotecario) { { bibliotecario: { email: 'invalidgmail.com', password: '123', nome: 'Errito' } } }
        run_test!
      end

      response '401', 'unauthenticated' do
        let(:Authorization) { nil } 
        let(:bibliotecario) { { bibliotecario: FactoryBot.attributes_for(:bibliotecario) } }
        run_test!
      end
      
      response '403', 'forbidden (not admin)' do
        let(:Authorization) { owner_token } 
        let(:bibliotecario) { { bibliotecario: FactoryBot.attributes_for(:bibliotecario) } }
        run_test!
      end
    end
  end

  path '/api/v1/bibliotecarios/{id}' do
    parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação', required: false
    # Remoção da criação de let! externo para evitar o bug de URI.

    #--------------------------------------------- GET -------------------------------------------------

    get 'Get bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for bibliotecario', required: true

      response '200', 'bibliotecario found' do
        let(:Authorization) { owner_token } 
        # Usa o ID do owner_bibliotecario que já está no escopo, convertido para string
        let(:id) { bibliotecario_owner.id.to_s } 
        run_test!
      end

      response '404', 'bibliotecario not found' do
        let(:Authorization) { owner_token }
        let(:id) { '-1' }
        run_test!
      end
    end

    #--------------------------------------------- DELETE -------------------------------------------------

    delete 'Delete bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for bibliotecario', required: true
      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação do administrador'

      response '204', 'bibliotecario deleted' do
        let!(:bibliotecario_para_deletar) { FactoryBot.create(:bibliotecario) }
        let(:Authorization) { admin_token }
        let(:id) { bibliotecario_para_deletar.id.to_s } 
        run_test!
      end

      response '404', 'bibliotecario not found' do
        let(:Authorization) { admin_token } 
        let(:id) { '-1' }
        run_test!
      end

    end

    #--------------------------------------------- UPDATE -------------------------------------------------

    put 'Update bibliotecario' do
      tags 'Api::V1::Bibliotecarios'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string, description: 'id for bibliotecario', required: true
      parameter name: 'Authorization', in: :header, type: :string, description: 'Token de autenticação'
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
        # Garante que o alvo tem primeiro_acesso: false
        let!(:bibliotecario_para_atualizar) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { admin_token }
        let(:id) { bibliotecario_para_atualizar.id.to_s } 
        
        # Correção do Payload
        let(:bibliotecario_payload) do
          { bibliotecario: { email: 'novoemail@gmail.com', password: 'novo password', nome: 'Novo Nome' } }
        end
        let(:bibliotecario) { bibliotecario_payload }
        before { bibliotecario_payload } 
        
        run_test!
      end

      response '404', 'bibliotecario not found' do
        let(:Authorization) { admin_token }
        let(:id) { '-1' }
        let(:bibliotecario_payload) do
          { bibliotecario: { email: 'novoemail@gmail.com', password: 'novo password', nome: 'Novo Nome' } }
        end
        let(:bibliotecario) { bibliotecario_payload }
        before { bibliotecario_payload }
        run_test!
      end

      response '422', 'update bibliotecario error' do
        # Garante que o alvo tem primeiro_acesso: false
        let!(:bibliotecario_para_erro) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) }
        let(:Authorization) { admin_token }
        let(:id) { bibliotecario_para_erro.id.to_s }
        
        # Payload com erro de validação (nome: '')
        let(:bibliotecario_payload) { { bibliotecario: { nome: '' } } }
        let(:bibliotecario) { bibliotecario_payload }
        before { bibliotecario_payload }
        
        run_test!
      end
      
      response '200', 'self-update' do
        let(:Authorization) { owner_token }
        # O ID deve ser o do owner (para self-update)
        let(:id) { bibliotecario_owner.id.to_s } 
        
        let(:bibliotecario_payload) do
          { bibliotecario: { email: 'owner.novo@email.com', nome: 'Novo Nome' } }
        end
        let(:bibliotecario) { bibliotecario_payload }
        before { bibliotecario_payload }
        
        run_test!
      end
      
      response '403', 'forbidden (not admin)' do
        let(:Authorization) { owner_token }
        # Tenta atualizar outro usuário
        let!(:target_bibliotecario) { FactoryBot.create(:bibliotecario, primeiro_acesso: false) } 
        let(:id) { target_bibliotecario.id.to_s }
        
        let(:bibliotecario_payload) do
          { bibliotecario: { nome: 'Novo Nome' } }
        end
        let(:bibliotecario) { bibliotecario_payload }
        before { bibliotecario_payload }
        
        run_test!
      end
    end
  end
end