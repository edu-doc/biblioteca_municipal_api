# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::BibliotecariosController, type: :controller do
  before(:each) do
    request.headers['Accept'] = 'application/vnd.biblioteca_municipal_api.v1'
  end

  describe 'GET /show' do
    before(:each) do
      @bibliotecario = FactoryBot.create :bibliotecario
      get :show, params: { id: @bibliotecario.id }, format: :json
    end

    it 'returns the information about a reporter on a hash' do
      bibliotecario_response = JSON.parse(response.body, symbolize_names: true)
      expect(bibliotecario_response[:email]).to eq(@bibliotecario.email)
    end
  end
end
