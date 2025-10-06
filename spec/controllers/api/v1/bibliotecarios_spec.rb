# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BibliotecariosController, type: :controller do
  describe 'GET /show' do
    before(:each) do
      @bibliotecario = FactoryBot.create :bibliotecario
      get :show, params: { id: @bibliotecario.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
      expect(bibliotecario_response[:email]).to eq(@bibliotecario.email)
    end

    it { should respond_with 200 }
  end

  describe 'POST  #create' do
    context 'when is successfully created' do
      before(:each) do
        @bibliotecario_atributos = FactoryBot.attributes_for :bibliotecario
        post :create, params: { bibliotecario: @bibliotecario_atributos }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        @bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(@bibliotecario_response[:email]).to eq(@bibliotecario_atributos[:email])
      end
      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_bibliotecario_atributos = { senha_provisoria: '12345678' }
        post :create, params: { bibliotecario: @invalid_bibliotecario_atributos }, format: :json
      end

      it 'renders an error json' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response[:errors][:email]).to include("can't be blank")
      end
    end
  end

  describe 'PUT/PATCH #update' do
    context 'when is sucessfully updated' do
      before(:each) do
        @bibliotecario = FactoryBot.create :bibliotecario, primeiro_acesso: false
        put :update, params: { id: @bibliotecario.id, bibliotecario: { email: 'new_email@example.com' } }, format: :json
      end

      it 'renders the json representation for the updated bibliotecario' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response[:email]).to eq('new_email@example.com')
      end

      it { should respond_with 200 }
    end

    context 'when is not updated' do
      before(:each) do
        @bibliotecario = FactoryBot.create :bibliotecario, primeiro_acesso: false
        put :update, params: { id: @bibliotecario.id, bibliotecario: { email: 'emailerrado.com' } }, format: :json
      end

      it 'renders an error json' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response[:errors][:email]).to include('is invalid')
      end
    end

    describe 'DELETE #destroy' do
      before(:each) do
        @bibliotecario = FactoryBot.create :bibliotecario
        delete :destroy, params: { id: @bibliotecario.id }, format: :json
      end

      it { should respond_with 204 }
    end
  end
end
