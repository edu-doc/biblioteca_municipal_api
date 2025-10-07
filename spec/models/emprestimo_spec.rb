# frozen_string_literal: true

# spec/models/emprestimo_spec.rb
require 'rails_helper'

RSpec.describe Emprestimo, type: :model do
  subject(:emprestimo) { FactoryBot.build(:emprestimo) }

  describe 'associations' do
    it { should belong_to(:usuario) }
    it { should belong_to(:livro) }
    it { should belong_to(:bibliotecario) }
  end

  describe 'attributes' do
    it { should respond_to(:data_emprestimo) }
    it { should respond_to(:data_devolucao) }
    it { should respond_to(:contador_renovacao) }
  end

  describe 'callbacks' do
    context 'after_create' do
      it 'change the status of the book to "emprestado"' do
        livro = FactoryBot.create(:livro, status: :disponivel)
        expect(livro).to be_disponivel
        FactoryBot.create(:emprestimo, livro: livro)
        livro.reload
        expect(livro).to be_emprestado
      end
    end
  end
end
