# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Livro, type: :model do
  let(:livro) { FactoryBot.build(:livro) }

  subject { livro }

  describe 'when respond to titulo, autor, etc' do
    it { should respond_to(:titulo) }
    it { should respond_to(:autor) }
    it { should respond_to(:status) }
    it { should respond_to(:observacoes) }
    it { should respond_to(:association) }
  end

  describe 'when titulo is present' do
    it { should be_valid }
  end

  describe 'validations' do
    it { should validate_presence_of(:titulo) }
    it { should validate_presence_of(:autor) }
    it { should validate_presence_of(:status) }
  end

  describe 'associations' do
    it { should belong_to(:categoria) }
  end

  describe 'enums' do
    it { should define_enum_for(:status).with_values(disponivel: 0, emprestado: 1) }
  end
end
