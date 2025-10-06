# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Bibliotecario, type: :model do
  let(:bibliotecario) { FactoryBot.build(:bibliotecario) }

  subject { bibliotecario }

  describe 'when respond to email, password, etc' do
    it { should respond_to(:email) }
    it { should respond_to(:password) }
    it { should respond_to(:nome) }
    it { should respond_to(:senha_provisoria) }
    it { should respond_to(:token) }
  end

  describe 'when email is present' do
    it { should be_valid }
  end

  describe 'when email is not present' do
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_confirmation_of(:password) }
    it { should validate_presence_of(:email) }
    it { should allow_value('email@domain.com').for(:email) }
    it { should validate_uniqueness_of(:token) }
  end

  describe '#gerador_token_autenticacao' do
    it 'generates a unique token' do
      allow(Devise).to receive(:friendly_token).and_return('auniquetoken123')
      bibliotecario.gerador_token_autenticacao
      expect(bibliotecario.token).to eq('auniquetoken123')
    end

    it 'generates another token when one has been taken' do
      existing_bibliotecario = FactoryBot.create(:bibliotecario, token: 'auniquetoken123')
      bibliotecario.gerador_token_autenticacao
      expect(bibliotecario.token).not_to eql existing_bibliotecario.token
    end
  end
end
