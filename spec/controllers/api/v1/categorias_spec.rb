# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CategoriasController, type: :controller do
  describe 'GET /index' do
    before(:each) do
      @categoria = FactoryBot.create :categoria
      get :index, params: {}, format: :json
    end

    it 'returns categorias' do
      categorias_response = JSON.parse(response.body, symbolize_names: true)
      expect(categorias_response.first[:nome]).to eq(@categoria.nome)
    end

    it { should respond_with 200 }
  end

  describe 'GET /show' do
    before(:each) do
      @categoria = FactoryBot.create :categoria
      get :show, params: { id: @categoria.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      categoria_response = JSON.parse(response.body, symbolize_names: true)
      expect(categoria_response[:nome]).to eq(@categoria.nome)
    end

    it { should respond_with 200 }
  end

  describe 'POST  #create' do
    context 'when is successfully created' do
      before(:each) do
        @categoria_atributos = FactoryBot.attributes_for :categoria
        post :create, params: { categoria: @categoria_atributos }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        @categoria_response = JSON.parse(response.body, symbolize_names: true)
        expect(@categoria_response[:nome]).to eq(@categoria_atributos[:nome])
      end
      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_categoria_atributos = { nome: '' }
        post :create, params: { categoria: @invalid_categoria_atributos }, format: :json
      end

      it 'renders an error json' do
        categoria_response = JSON.parse(response.body, symbolize_names: true)
        expect(categoria_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        categoria_response = JSON.parse(response.body, symbolize_names: true)
        expect(categoria_response[:errors][:nome]).to include("can't be blank")
      end
    end
  end
end
