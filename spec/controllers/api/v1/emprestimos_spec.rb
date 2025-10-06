# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::EmprestimosController, type: :controller do
  describe 'GET /index' do
    before(:each) do
      @emprestimo = FactoryBot.create :emprestimo
      get :index, params: {}, format: :json
    end

    it 'returns emprestimos' do
      emprestimo_response = JSON.parse(response.body, symbolize_names: true)
      expect(emprestimo_response.first[:usuario_id]).to eq(@emprestimo.usuario_id)
      expect(emprestimo_response.first[:bibliotecario_id]).to eq(@emprestimo.bibliotecario_id)
      expect(emprestimo_response.first[:livro_id]).to eq(@emprestimo.livro_id)
    end

    it { should respond_with 200 }
  end

  describe 'GET /show' do
    before(:each) do
      @emprestimo = FactoryBot.create :emprestimo
      get :show, params: { id: @emprestimo.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      emprestimo_response = JSON.parse(response.body, symbolize_names: true)
      expect(emprestimo_response[:usuario_id]).to eq(@emprestimo.usuario_id)
      expect(emprestimo_response[:bibliotecario_id]).to eq(@emprestimo.bibliotecario_id)
      expect(emprestimo_response[:livro_id]).to eq(@emprestimo.livro_id)
    end

    it { should respond_with 200 }
  end

  describe 'POST  #create' do
    context 'when is successfully created' do
      before(:each) do
        @categoria = FactoryBot.create(:categoria)
        @livro = FactoryBot.create(:livro, categoria_id: @categoria.id)
        @usuario = FactoryBot.create(:usuario)
        @bibliotecario = FactoryBot.create(:bibliotecario)
        @emprestimo_atributos = FactoryBot.attributes_for(:emprestimo)
        @emprestimo_atributos[:livro_id] = @livro.id
        @emprestimo_atributos[:usuario_id] = @usuario.id
        @emprestimo_atributos[:bibliotecario_id] = @bibliotecario.id
        post :create, params: { emprestimo: @emprestimo_atributos }, format: :json
      end

      it 'renders the json representation for the user record just created' do
        emprestimo_response = JSON.parse(response.body, symbolize_names: true)
        expect(emprestimo_response[:usuario_id]).to eq(@emprestimo_atributos[:usuario_id])
        expect(emprestimo_response[:bibliotecario_id]).to eq(@emprestimo_atributos[:bibliotecario_id])
        expect(emprestimo_response[:livro_id]).to eq(@emprestimo_atributos[:livro_id])
      end
      it { should respond_with 201 }
    end

    context 'when is not created' do
      before(:each) do
        @invalid_emprestimo_atributos = { livro_id: '' }
        post :create, params: { emprestimo: @invalid_emprestimo_atributos }, format: :json
      end

      it 'renders an error json' do
        emprestimo_response = JSON.parse(response.body, symbolize_names: true)
        expect(emprestimo_response).to have_key(:errors)
      end

      it 'renders the json errors on why the user could not be created' do
        emprestimo_response = JSON.parse(response.body, symbolize_names: true)
        expect(emprestimo_response[:errors][:livro]).to include('must exist')
      end
    end
  end
end
