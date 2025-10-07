# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsuarioMailer, type: :mailer do
  describe 'enviar_senha_emprestimo' do
    let(:usuario) { FactoryBot.create(:usuario) }
    let(:mail) { UsuarioMailer.enviar_senha_emprestimo(usuario) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Sua Senha de Empréstimo da Biblioteca Municipal')
      expect(mail.to).to eq([usuario.email])
      expect(mail.from).to eq(['from@example.com'])
    end

    it 'renders the body' do
      expect(mail.body.encoded).to match(usuario.nome)
      expect(mail.body.encoded).to match(usuario.senha)
    end
  end
end
