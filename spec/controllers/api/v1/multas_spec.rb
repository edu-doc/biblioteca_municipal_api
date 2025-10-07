# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::MultasController, type: :controller do
  describe 'GET /index' do
    before(:each) do
      bibliotecario = FactoryBot.create(:bibliotecario, primeiro_acesso: false)

      @multa = FactoryBot.create :multum

      request.headers['Authorization'] = bibliotecario.token

      get :index, params: {}, format: :json
    end

    it 'returns multas' do
      multa_response = JSON.parse(response.body, symbolize_names: true)
      expect(multa_response.first[:emprestimo_id]).to eq(@multa.emprestimo_id)
    end

    it { should respond_with 200 }
  end

  describe 'GET /show' do
    before(:each) do
      bibliotecario = FactoryBot.create(:bibliotecario, primeiro_acesso: false)

      @multa = FactoryBot.create :multum

      request.headers['Authorization'] = bibliotecario.token

      get :show, params: { id: @multa.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      multa_response = JSON.parse(response.body, symbolize_names: true)
      expect(multa_response[:emprestimo_id]).to eq(@multa.emprestimo_id)
    end

    it { should respond_with 200 }
  end
end
