# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::LivrosController, type: :controller do
  describe 'GET /index' do
    before(:each) do
      @livro = FactoryBot.create :livro
      get :index, params: {}, format: :json
    end

    it 'returns livros' do
      livros_response = JSON.parse(response.body, symbolize_names: true)
      expect(livros_response.first[:titulo]).to eq(@livro.titulo)
      expect(livros_response.first[:autor]).to eq(@livro.autor)
    end

    it { should respond_with 200 }
  end

  describe 'GET /show' do
    before(:each) do
      @livro = FactoryBot.create :livro
      get :show, params: { id: @livro.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      livro_response = JSON.parse(response.body, symbolize_names: true)
      expect(livro_response[:titulo]).to eq(@livro.titulo)
      expect(livro_response[:autor]).to eq(@livro.autor)
    end

    it { should respond_with 200 }
  end

  describe 'POST  #create' do
    context 'when is successfully created' do
      before(:each) do
        @categoria = FactoryBot.create(:categoria)
        @livro_atributos = FactoryBot.attributes_for(:livro)
        @livro_atributos[:status] = :disponivel
        @livro_atributos[:categoria_id] = @categoria.id
        post :create, params: { livro: @livro_atributos }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        @livro_response = JSON.parse(response.body, symbolize_names: true)
        expect(@livro_response[:titulo]).to eq(@livro_atributos[:titulo])
        expect(@livro_response[:autor]).to eq(@livro_atributos[:autor])
      end
      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_livro_atributos = { titulo: '' }
        post :create, params: { livro: @invalid_livro_atributos }, format: :json
      end

      it 'renders an error json' do
        livro_response = JSON.parse(response.body, symbolize_names: true)
        expect(livro_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        livro_response = JSON.parse(response.body, symbolize_names: true)
        expect(livro_response[:errors][:titulo]).to include("can't be blank")
      end
    end
  end
end
