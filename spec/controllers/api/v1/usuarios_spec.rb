# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::UsuariosController, type: :controller do
  describe 'GET /show' do
    before(:each) do
      @usuario = FactoryBot.create :usuario
      get :show, params: { id: @usuario.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      usuario_response = JSON.parse(response.body, symbolize_names: true)
      expect(usuario_response[:cpf]).to eq(@usuario.cpf)
    end

    it { should respond_with 200 }
  end

  describe 'POST  #create' do
    context 'when is successfully created' do
      before(:each) do
        @usuario_atributos = FactoryBot.attributes_for :usuario
        post :create, params: { usuario: @usuario_atributos }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        @usuario_response = JSON.parse(response.body, symbolize_names: true)
        expect(@usuario_response[:cpf]).to eq(@usuario_atributos[:cpf])
      end
      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_usuario_atributos = { password: '12345678' }
        post :create, params: { usuario: @invalid_usuario_atributos }, format: :json
      end

      it 'renders an error json' do
        usuario_response = JSON.parse(response.body, symbolize_names: true)
        expect(usuario_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        usuario_response = JSON.parse(response.body, symbolize_names: true)
        expect(usuario_response[:errors][:cpf]).to include("can't be blank")
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is sucessfully updated' do
      before(:each) do
        @usuario = FactoryBot.create :usuario
        put :update, params: { id: @usuario.id, usuario: { cpf: '885.359.030-03' } }, format: :json
      end

      it 'renders the json representation for the updated usuario' do
        usuario_response = JSON.parse(response.body, symbolize_names: true)
        expect(usuario_response[:cpf]).to eq('885.359.030-03')
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        @usuario = FactoryBot.create :usuario
        put :update, params: { id: @usuario.id, usuario: { cpf: '111.222.333-44' } }, format: :json
      end

      it 'renders an error json' do
        usuario_response = JSON.parse(response.body, symbolize_names: true)
        expect(usuario_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        usuario_response = JSON.parse(response.body, symbolize_names: true)
        expect(usuario_response[:errors][:cpf]).to include('is invalid')
      end
    end

    describe 'DELETE #destroy' do
      before(:each) do
        @usuario = FactoryBot.create :usuario
        delete :destroy, params: { id: @usuario.id }, format: :json
      end

      it { should respond_with 204 }
    end
  end
end
