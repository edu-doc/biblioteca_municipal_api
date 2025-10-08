# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BibliotecariosController, type: :controller do
  
  let!(:admin_bibliotecario) { FactoryBot.create :bibliotecario, role: :admin, primeiro_acesso: false }
  let!(:default_bibliotecario) { FactoryBot.create :bibliotecario, role: :default, primeiro_acesso: false }
  let(:admin_token) { admin_bibliotecario.token }
  let(:default_token) { default_bibliotecario.token }

  # --- GET /show ---
  describe 'GET /show' do
    before(:each) do
      request.headers['Authorization'] = default_token
      @bibliotecario = FactoryBot.create :bibliotecario
      get :show, params: { id: @bibliotecario.id }, format: :json
    end

    it 'returns the information about the reporter on a hash' do
      bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
      expect(bibliotecario_response[:email]).to eq(@bibliotecario.email)
    end

    it { should respond_with 200 }
  end

  # --- POST #create ---
  describe 'POST #create' do
    let(:bibliotecario_atributos) { FactoryBot.attributes_for :bibliotecario }

    context 'when authenticated as ADMIN and successfully created' do
      before(:each) do
        request.headers['Authorization'] = admin_token
        post :create, params: { bibliotecario: bibliotecario_atributos }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response[:email]).to eq(bibliotecario_atributos[:email])
      end
      it { should respond_with 201 }
    end

    context 'when authenticated as ADMIN but with invalid data' do
      before(:each) do
        request.headers['Authorization'] = admin_token
        @invalid_bibliotecario_atributos = { senha_provisoria: '12345678', email: nil }
        post :create, params: { bibliotecario: @invalid_bibliotecario_atributos }, format: :json
      end

      it 'renders an error json' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response).to have_key(:errors)
        expect(bibliotecario_response[:errors][:email]).to include("can't be blank")
      end
      it { should respond_with 422 }
    end

    context 'when NOT authenticated (missing token)' do
      before(:each) do
        post :create, params: { bibliotecario: bibliotecario_atributos }, format: :json
      end

      it 'responds with 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated as DEFAULT (non-admin)' do
      before(:each) do
        request.headers['Authorization'] = default_token
        post :create, params: { bibliotecario: bibliotecario_atributos }, format: :json
      end

      it 'responds with 403 Forbidden' do
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to include('Acesso negado. Apenas administradores podem realizar esta ação.')
      end
    end
  end

  # --- PUT/PATCH #update ---
  describe 'PUT/PATCH #update' do
    let!(:target_bibliotecario) { FactoryBot.create :bibliotecario, primeiro_acesso: true }

    context 'when authenticated as ADMIN but with invalid data' do
      before(:each) do
        request.headers['Authorization'] = admin_token
        @bibliotecario = FactoryBot.create :bibliotecario, primeiro_acesso: false
        
        put :update, params: { id: @bibliotecario.id, bibliotecario: { nome: '' }, format: :json }
      end

      it 'renders an error json' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be updated' do
        bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
        expect(bibliotecario_response[:errors][:nome]).to include("can't be blank")
      end

      it { should respond_with 422 }
    end

    context 'when NOT authenticated (missing token)' do
      before(:each) do
        put :update, params: { id: target_bibliotecario.id, bibliotecario: { email: 'new_email@example.com' } }, format: :json
      end

      it 'responds with 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated as DEFAULT (non-admin)' do
      before(:each) do
        request.headers['Authorization'] = default_token
        put :update, params: { id: target_bibliotecario.id, bibliotecario: { email: 'new_email@example.com' } }, format: :json
      end

      it 'responds with 403 Forbidden' do
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to include('Acesso negado. Apenas administradores podem realizar esta ação.')
      end
    end
  end

  # --- DELETE #destroy ---
  describe 'DELETE #destroy' do
    let!(:bibliotecario_to_delete) { FactoryBot.create :bibliotecario }

    context 'when authenticated as ADMIN and successful' do
      before(:each) do
        request.headers['Authorization'] = admin_token
        delete :destroy, params: { id: bibliotecario_to_delete.id }, format: :json
      end

      it { should respond_with 204 }
    end

    context 'when NOT authenticated (missing token)' do
      before(:each) do
        delete :destroy, params: { id: bibliotecario_to_delete.id }, format: :json
      end

      it 'responds with 401 Unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context 'when authenticated as DEFAULT (non-admin)' do
      before(:each) do
        request.headers['Authorization'] = default_token
        delete :destroy, params: { id: bibliotecario_to_delete.id }, format: :json
      end

      it 'responds with 403 Forbidden' do
        expect(response).to have_http_status(:forbidden)
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to include('Acesso negado. Apenas administradores podem realizar esta ação.')
      end
    end
  end
end