# frozen_string_literal: true

class UsuarioMailer < ApplicationMailer
  def enviar_senha_emprestimo(usuario)
    @usuario = usuario

    mail(to: @usuario.email, subject: 'Sua Senha de Empréstimo da Biblioteca Municipal')
  end
end
