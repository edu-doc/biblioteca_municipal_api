# frozen_string_literal: true

class UsuarioMailerPreview < ActionMailer::Preview
  def enviar_senha_emprestimo
    usuario = Usuario.new(nome: 'Teste Senha', email: 'teste@exemplo.com', senha: 'senha123')
    UsuarioMailer.enviar_senha_emprestimo(usuario)
  end
end
