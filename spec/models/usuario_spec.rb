# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Usuario, type: :model do
  let(:usuario) { FactoryBot.build(:usuario) }

  subject { usuario }

  describe 'when respond to email, password, etc' do
    it { should respond_to(:email) }
    it { should respond_to(:senha) }
    it { should respond_to(:nome) }
    it { should respond_to(:telefone) }
    it { should respond_to(:cpf) }
  end

  describe 'when email is present' do
    it { should be_valid }
  end

  describe 'when email is not present' do
    it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
    it { should validate_presence_of(:email) }
    it { should allow_value('email@domain.com').for(:email) }
    it { should validate_uniqueness_of(:cpf).ignoring_case_sensitivity }
  end

  describe '#gerar_senha_emprestimo' do
    it 'generates a password' do
      expect(usuario.senha).to be_nil
      usuario.save
      expect(usuario.senha).not_to be_nil
    end
  end
end
