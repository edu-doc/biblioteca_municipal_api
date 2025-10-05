# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  describe 'POST #create' do
    before(:each) do
      @bibliotecario = FactoryBot.create(:bibliotecario)
    end

    context 'when the credentials are correct' do
      before(:each) do
        credentials = { email: @bibliotecario.email, password: @bibliotecario.password }
        post :create, params: { session: credentials }
      end

      it 'returns the user record corresponding to the given credentials' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        @bibliotecario.reload
        expect(json_response[:token]).to eql @bibliotecario.token
      end

      it { should respond_with 200 }
    end

    context 'when the credentials are incorrect' do
      before(:each) do
        credentials = { email: @bibliotecario.email, password: '@' }
        post :create, params: { session: credentials }
      end

      it 'returns an error' do
        json_response = JSON.parse(response.body, symbolize_names: true)
        expect(json_response[:errors]).to eql 'Invalid email or password'
      end

      it { should respond_with 401 }
    end
  end

  describe 'DELETE #destroy' do
    before(:each) do
      @bibliotecario = FactoryBot.create(:bibliotecario)
      sign_in(@bibliotecario)
      delete :destroy, params: { token: @bibliotecario.token }
    end

    it { should respond_with 204 }
  end
end
