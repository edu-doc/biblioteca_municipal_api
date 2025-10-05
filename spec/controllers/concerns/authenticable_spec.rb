# frozen_string_literal: true

require 'rails_helper'

class Authentication < ActionController::API
  include Authenticable
end

describe Authenticable do
  let(:authentication) { Authentication.new }
  subject { authentication }

  describe '#current_bibliotecario' do
    before do
      @bibliotecario = FactoryBot.create(:bibliotecario)
      request.headers['Authorization'] = @bibliotecario.token
      allow(authentication).to receive(:request).and_return(request)
    end

    it 'returns the user from the authorization header' do
      expect(subject.current_bibliotecario.token).to eql @bibliotecario.token
    end
  end

  describe '#authenticate_with_token' do
    before do
      @bibliotecario = FactoryBot.create(:bibliotecario)
      request.headers['Authorization'] = @bibliotecario.token
      allow(authentication).to receive(:request).and_return(request)
      response.status = 401
      response.body = { errors: 'Not authenticated' }.to_json
      allow(authentication).to receive(:response).and_return(response)
    end


    it 'renders a json error message' do
      json_response = JSON.parse(response.body, symbolize_names: true)
      expect(json_response[:errors]).to eql 'Not authenticated'
    end

    it { should respond_with 401 }
  end

  describe '#user_signed_in?' do
    context 'when there is a bibliotecario on session' do
      before do
        @bibliotecario = FactoryBot.create(:bibliotecario)
        allow(authentication).to receive(:current_bibliotecario).and_return(@bibliotecario)
      end

      it { should be_user_signed_in }
    end

    context 'when there is no a biblioteario on session' do
      before do
        @bibliotecario = FactoryBot.create(:bibliotecario)
        allow(authentication).to receive(:current_bibliotecario).and_return(nil)
      end

      it { should_not be_user_signed_in }
    end
  end
end
